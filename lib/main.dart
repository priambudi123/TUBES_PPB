import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/auth/login.dart';
import 'package:tubes_ppb/firebase_options.dart';
import 'package:tubes_ppb/screen/home.dart';
import 'package:tubes_ppb/component/wishlist.dart';  // Import Wishlist atau provider lainnya

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Wishlist()),  // Tambahkan provider Wishlist atau sesuaikan dengan provider lainnya
        // ...provider lainnya
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
