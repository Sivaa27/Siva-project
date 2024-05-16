import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'EquipmentDetailsPage.dart';
import 'model/equipmentmodel.dart';

class nfcRead extends StatefulWidget {
  const nfcRead({Key? key}) : super(key: key);

  @override
  State<nfcRead> createState() => _nfcReadState();
}

class _nfcReadState extends State<nfcRead> {
  String? _barcode;
  late TextEditingController _searchController;
  List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Equipment>> _performSearch(String keyword) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/equipmentquery'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'keyword': keyword,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Equipment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load equipments');
    }
  }

  Color getColorBasedOnDate(String nextDate) {
    DateTime next = DateTime.parse(nextDate);
    DateTime now = DateTime.now();
    int difference = next.difference(now).inDays;
    if (difference <= 30) {
      return Colors.red;
    }
    return Colors.white;
  }

  void _showDetails(BuildContext context, Equipment equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentDetailsPage(equipment: equipment),
      ),
    );
  }

  void _showSearchResultsDialog(List<Equipment> equipments) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Results'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: equipments.length,
              itemBuilder: (context, index) {
                Equipment equipment = equipments[index];
                Color cardColor = getColorBasedOnDate(equipment.nextdate);
                return Card(
                  color: cardColor,
                  child: ListTile(
                    title: Text(equipment.eq_name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Serial Number: ${equipment.eq_serial}"),
                        Text("Hospital: ${equipment.eq_hospital}"),
                        Text("Next Date: ${equipment.nextdate}"),
                      ],
                    ),
                    onTap: () {
                      _showDetails(context, equipment);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Equipment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Content shrinks to minimum
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 200),
            Text(
              _barcode == null ? 'SCAN RFID' : 'RFID Scanned!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            _barcode == null
                ? // Show loading animation only if _barcode is null
            SpinKitRipple(
              color: Theme.of(context).primaryColor,
              size: 80.0,
            )
                : SizedBox(), // Empty container if barcode is scanned
            BarcodeKeyboardListener(
              bufferDuration: Duration(milliseconds: 200),
              onBarcodeScanned: (barcode) {
                setState(() {
                  _barcode = barcode;
                });
                _searchController.text = barcode;
                _performSearch(barcode).then((equipments) {
                  setState(() {
                    _equipments = equipments;
                  });
                  _showSearchResultsDialog(equipments);
                }).catchError((e) {
                  print('Error: $e');
                });
              },
              useKeyDownEvent: Platform.isWindows,
              child: Container(), // Dummy child widget
            ),
          ],
        ),
      ),
    );
  }
}

