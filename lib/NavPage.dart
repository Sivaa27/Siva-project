import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:ppm/user/user_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppm/home.dart';
import 'package:ppm/profile.dart';
import 'package:ppm/vendor_main.dart';
import 'package:ppm/user/user_main.dart'; // Import user_main page

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  Color color = Color(0xA30098FF);
  String? hospital;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _loadHospitalValue();
  }

  Future<void> _loadHospitalValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hospital = prefs.getString('hospital');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hospital == null) {
      // Show a loading indicator while waiting for the hospital value to load
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: buildBar(),
    );
  }

  Widget buildPages() {
    if (hospital == 'Vendor') {
      return vendorMain();
    } else {
      switch (index) {
        case 1:
          return manageAccount();
        default:
          return userMain();
      }
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
