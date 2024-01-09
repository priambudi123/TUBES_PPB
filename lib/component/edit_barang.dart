import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_ppb/data/data.dart';
import 'package:tubes_ppb/screen/home.dart';
import 'package:tubes_ppb/style/color.dart';

class EditBarang extends StatefulWidget {
  final Product data;
  const EditBarang({Key? key, required this.data}) : super(key: key);

  @override
  State<EditBarang> createState() => EditBarangState();
}

class EditBarangState extends State<EditBarang> {
  File? _image;
  final picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.data.name;
    _priceController.text = widget.data.price;
    _stockController.text = widget.data.stock;
    _descController.text = widget.data.desc;
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> uploadImageToFirebase(String id) async {
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('product/$id');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      return await storageTaskSnapshot.ref.getDownloadURL();
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 200,
                          width: 200,
                        )
                      : SizedBox(
                          height: mediaQuery.size.height / 3,
                          child: Image.network(widget.data.image),
                        ),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text('Select Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithIcon(
                FontAwesomeIcons.signature,
                'Name',
                'Enter product name',
                _nameController,
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithIcon(
                FontAwesomeIcons.boxesStacked,
                'Stock',
                'Enter product stock',
                _stockController,
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithIcon(
                FontAwesomeIcons.circleInfo,
                'Description',
                'Enter product description',
                _descController,
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithIcon(
                FontAwesomeIcons.tags,
                'Price',
                'Enter product price',
                _priceController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildElevatedButton('Update', Colors.green, () async {
                      String productID = widget.data.id;
                      if (_image != null) {
                        String url = await uploadImageToFirebase(productID);
                        final db = FirebaseFirestore.instance;
                        db.collection("product").doc(productID).set({
                          "image": url,
                          "name": _nameController.text,
                          "stock": _stockController.text,
                          "price": _priceController.text,
                          "desc": _descController.text
                        });
                      } else {
                        final db = FirebaseFirestore.instance;
                        db.collection("product").doc(productID).set({
                          "name": _nameController.text,
                          "stock": _stockController.text,
                          "price": _priceController.text,
                          "desc": _descController.text
                        }, SetOptions(merge: true));
                      }
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }),
                    _buildElevatedButton('Delete', Colors.red, () {
                      _showDeleteConfirmationDialog();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
    IconData icon,
    String labelText,
    String hintText,
    TextEditingController controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FaIcon(icon),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: gray),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildElevatedButton(
    String text,
    Color color,
    void Function() onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct();
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct() async {
    String productID = widget.data.id;
    final db = FirebaseFirestore.instance;
    Reference storageRef = FirebaseStorage.instance.ref();
    db.collection("product").doc(productID).delete();
    final desertRef = storageRef.child("product/$productID");
    await desertRef.delete();
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => Home(),
      ),
    );
  }
}
