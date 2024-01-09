import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_ppb/component/image_profile.dart';
import 'package:tubes_ppb/style/color.dart';

class ChangeProfile extends StatefulWidget {
  final GlobalKey<ImageProfileState> childKey;
  const ChangeProfile({super.key, required this.childKey});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  File? _image;
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;
  String imageUrl = '';
  final storage = FirebaseStorage.instance;

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

  Future uploadImageToFirebase() async {
    String uid = user?.uid ?? '';
    if (_image != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child('profile_image/$uid');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL();
      print('Image URL: $imageURL');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await getImage();
        await uploadImageToFirebase();
        widget.childKey.currentState?.changeState();
      },
      icon: CircleAvatar(
        radius: 12,
        backgroundColor: white,
        child: FaIcon(
          FontAwesomeIcons.pen,
          size: 10,
          color: black,
        ),
      ),
    );
  }
}