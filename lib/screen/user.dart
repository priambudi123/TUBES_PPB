import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/auth/login.dart';
import 'package:tubes_ppb/component/change_profile.dart';
import 'package:tubes_ppb/component/edit_profile.dart';
import 'package:tubes_ppb/component/image_profile.dart';
import 'package:tubes_ppb/screen/contact_person.dart';
import 'package:tubes_ppb/style/color.dart';

class User extends StatelessWidget {
  User({super.key});
  final GlobalKey<ImageProfileState> childKey = GlobalKey<ImageProfileState>();

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final auth = FirebaseAuth.instance;
  var data;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey[800],
            child: StreamBuilder(
              stream: db.collection("userData").doc(uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                data = snapshot.data!.data();
                print(data);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImageProfile(key: childKey, path: "profile_image/$uid"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?['username'] ?? 'error',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ChangeProfile(childKey: childKey),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfile(data: data),
                      ),
                    );
                  },
                  leading:
                      FaIcon(FontAwesomeIcons.user, color: Colors.grey[800]),
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ContactPersonScreen(),
                      ),
                    );
                  },
                  leading:
                      FaIcon(FontAwesomeIcons.person, color: Colors.grey[800]),
                  title: Text(
                    "Contact Person",
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showLogoutDialog(context);
                  },
                  leading: FaIcon(FontAwesomeIcons.signOutAlt,
                      color: Colors.grey[800]),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
