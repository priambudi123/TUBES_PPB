import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_ppb/style/color.dart';
import 'package:uuid/uuid.dart';

class AddBarang extends StatefulWidget {
  const AddBarang({Key? key});

  @override
  State<AddBarang> createState() => AddBarangState();
}

class AddBarangState extends State<AddBarang> {
  File? _image;
  final picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _desckController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(String id) async {
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('product/$id');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
      print('Image URL: $imageURL');
      return imageURL;
    } else {
      print('No image selected.');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithIcon(
              FontAwesomeIcons.signature,
              'Name',
              'Tulis nama disini',
              _nameController,
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithIcon(
              FontAwesomeIcons.boxesStacked,
              'Stock',
              'Tulis stok disini',
              _stockController,
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithIcon(
              FontAwesomeIcons.boxesStacked,
              'Deskripsi',
              'Tulis deskripsi disini',
              _desckController,
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithIcon(
              FontAwesomeIcons.tags,
              'Price',
              'Tulis harga disini',
              _priceController,
            ),
            ElevatedButton(
              onPressed: () async {
                String productID = const Uuid().v4();
                if (_image != null) {
                  String url = await uploadImageToFirebase(productID);
                  final db = FirebaseFirestore.instance;
                  db.collection("product").doc(productID).set({
                    "image": url,
                    "name": _nameController.text,
                    "stock": _stockController.text,
                    "desc": _desckController.text,
                    "price": _priceController.text
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Upload'),
            ),
          ],
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
}
