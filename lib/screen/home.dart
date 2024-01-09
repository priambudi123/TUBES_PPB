import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/screen/barang.dart';
import 'package:tubes_ppb/screen/homepage.dart';
import 'package:tubes_ppb/screen/user.dart';
import 'package:tubes_ppb/style/color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> pageList = [
    Homepage(),
    Barang(),
    User(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pageList[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bagShopping),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: black,
        unselectedItemColor: black.withOpacity(0.5),
        onTap: _onItemTapped,
      ),
    );
  }
}
