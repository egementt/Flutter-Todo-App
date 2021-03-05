import 'package:flutter/material.dart';
import 'package:flutter_todo/views/home_page.dart';
import 'package:flutter_todo/views/profile_page.dart';

class MyBottomNavBar extends StatefulWidget {
  MyBottomNavBar({Key key}) : super(key: key);

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;

  List<Widget> navList = <Widget>[
    HomePage(),
    ProfilePage()
  ];

  onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        currentIndex: _currentIndex,
        onTap: onTap,
      ),
      body: navList[_currentIndex],
    );
  }
}
