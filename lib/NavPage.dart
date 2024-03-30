import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:ppm/home.dart';
import 'package:ppm/profile.dart';
import 'package:ppm/vendor_main.dart';



class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  Color color = Color(0xA30098FF);

  @override
  void initState() {
    super.initState();

  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: buildBar(),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 1:
        return manageAccount();
      default:
        return vendorMain();
    }
  }

  Widget buildBar() {
    final inactiveColor = Colors.grey.shade800;

    return BottomNavyBar(
      itemCornerRadius: 15.0,
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          title: Text('Home'),
          textAlign: TextAlign.center,
          icon: LineIcon.home(),
          activeColor: color,
          inactiveColor: inactiveColor,
        ),
        BottomNavyBarItem(
          title: Text('My Profile'),
          textAlign: TextAlign.center,
          icon: LineIcon.user(),
          activeColor: color,
          inactiveColor: inactiveColor,
        ),
      ],
    );
  }
}
