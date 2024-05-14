import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'vendor_main.dart'; // Import your vendor_main.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes here
      routes: {
        '/': (context) => loginScreen(), // Default route
        '/vendorMain': (context) => vendorMain(), // Route for vendorMain
        // Add more routes as needed
      },
    );
  }
}
