import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/style/color.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  EditProfile({Key? key, required this.data});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.data['username'];
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: gray, // Sesuaikan dengan warna tema aplikasi
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              final db = FirebaseFirestore.instance;
              await db.collection("userData").doc(uid).set(
                {
                  "username": _usernameController.text,
                },
                SetOptions(merge: true),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: mediaQuery.size.width / 1.2,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: black),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final db = FirebaseFirestore.instance;
                await db.collection("userData").doc(uid).set(
                  {
                    "username": _usernameController.text,
                  },
                  SetOptions(merge: true),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: white, // Sesuaikan dengan warna tema aplikasi
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
