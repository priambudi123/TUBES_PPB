import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tubes_ppb/style/color.dart';

class ImageProfile extends StatefulWidget {
  final String path;
  const ImageProfile({super.key, required this.path});

  @override
  State<ImageProfile> createState() => ImageProfileState();
}

class ImageProfileState extends State<ImageProfile> {
  late Future<String> imageUrl;
  Future<String> getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      print("manuk : ${await ref.getDownloadURL()}");
      return await ref.getDownloadURL();
    } catch (error) {
      return "https://firebasestorage.googleapis.com/v0/b/tubes-mobile2.appspot.com/o/profile_image%2Fno-photo-available.png?alt=media&token=9a7d9cd6-62af-45ef-bd8c-1f49fc502f03";
    }
  }

  @override
  void initState() {
    imageUrl = getImageUrl(widget.path);
    super.initState();
  }

  void changeState() {
    setState(() {
      imageUrl = getImageUrl(widget.path);
      print("running ini");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: imageUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: 40.0,
            backgroundColor: black,
            child: const CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(snapshot.data!),
            backgroundColor: black,
          );
        } else {
          return const Center(child: Text('No image available'));
        }
      },
    );
  }
}
