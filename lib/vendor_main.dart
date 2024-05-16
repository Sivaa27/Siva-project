import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppm/newHospital.dart';
import 'package:ppm/nfcread.dart';
import 'package:ppm/searchQuery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addEquip.dart';
import 'newUser.dart';

class vendorMain extends StatefulWidget {
  const vendorMain({super.key});

  @override
  State<vendorMain> createState() => _vendorMainState();
}

class _vendorMainState extends State<vendorMain> {
  String getName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Dashboard'),
        backgroundColor: Colors.blue, // Change app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Hello, $getName!',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildDashboardItem(
                    icon: Icons.add_circle,
                    label: 'Add Item',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => addEquip()));
                    },
                  ),
                  _buildDashboardItem(
                    icon: Icons.search,
                    label: 'Search Equipment',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => searchQuery()));
                    },
                  ),
                  _buildDashboardItem(
                    icon: Icons.calendar_today,
                    label: 'NFC Scanner',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => nfcRead()));
                    },
                  ),
                  _buildDashboardItem(
                    icon: Icons.person_add,
                    label: 'Add New User',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => newUser()));
                    },
                  ),
                  _buildDashboardItem(
                    icon: Icons.home_work,
                    label: 'Add New Hospital',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => newHospital()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey, // Change item color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      getName = prefs.getString('name') ?? '';
    });
  }
}
