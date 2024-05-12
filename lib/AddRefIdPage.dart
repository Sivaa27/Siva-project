import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:ppm/vendor_main.dart';

import 'CallApi/CallApi.dart';
import 'TextFieldwithNoKeyboard.dart';

class AddRefIDPage extends StatefulWidget {
  final String eqname;
  final String eqserial;
  final String eqmanuf;
  final String eqdepart;
  final String eqward;
  final String? selectedUserName;
  final String? selectedHospitalName;
  final String? selectedEquipmentClass;
  final String? selectedEquipmentType;
  final String? selectedUserEmail;
  final String formattedDate;

  const AddRefIDPage({
    Key? key,
    required this.eqname,
    required this.eqserial,
    required this.eqmanuf,
    required this.eqdepart,
    required this.eqward,
    this.selectedUserName,
    this.selectedHospitalName,
    this.selectedEquipmentClass,
    this.selectedEquipmentType,
    this.selectedUserEmail,
    required this.formattedDate,
  }) : super(key: key);

  @override
  _AddRefIDPageState createState() => _AddRefIDPageState();
}

class _AddRefIDPageState extends State<AddRefIDPage> {
  String? _scannedRFID;
  late TextEditingController _rfidTextController;
  DateTime currentDate = DateTime.now();
  String nextYearDate1 = '';
  String? _refId;

  @override
  void initState() {
    super.initState();
    _rfidTextController = TextEditingController();
  }

  @override
  void dispose() {
    _rfidTextController.dispose();
    super.dispose();
  }

  void _updateScannedRFID(String value) {
    setState(() {
      _scannedRFID = value;

      // Check if the length of the entered RFID value is equal to the expected length
      if (_scannedRFID != null && _scannedRFID!.length == 10) {
        _refId = _scannedRFID;
        print(_refId);
        // Display the message once the last value is entered and completed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('RFID scanned!'),
            duration: Duration(seconds: 2),
          ),
        );
        _scannedRFID = null;
        _skipRFIDScanning();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ref ID'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Use custom TextField
            TextFieldWithNoKeyboard(
              controller: _rfidTextController,
              cursorColor: Colors.transparent,
              style: TextStyle(color: Colors.transparent),
              onValueUpdated: _updateScannedRFID,
              autofocus: true, // Make the text field active
            ),
            Text(
              _scannedRFID ?? 'RFID not scanned yet',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: _skipRFIDScanning,
              child: Text('Skip RFID Scanning'),
            ),
            BarcodeKeyboardListener(
              bufferDuration: Duration(milliseconds: 200),
              onBarcodeScanned: (barcode) {
                _rfidTextController.text = barcode;
                _updateScannedRFID(barcode);
              },
              useKeyDownEvent: true,
              child: Container(), // Dummy child widget
            ),
          ],
        ),
      ),
    );
  }

  void _skipRFIDScanning() {
    DateTime nextYearDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    nextYearDate1 = DateFormat('yyyy-MM-dd').format(nextYearDate);
    _submitFunction();
  }

  void _submitFunction() async {
    // Your submit function code here
    SnackBar(
      content: Text('Please Wait!'),
      duration: Duration(seconds: 2),
    );
    String refId = _refId ?? 'Not Set'; // Use the value of _refId if it's set, otherwise use 'Not Set'

    var data = {
      'eq_name': widget.eqname,
      'eq_serial': widget.eqserial,
      'eq_manuf': widget.eqmanuf,
      'eq_hospital': widget.selectedHospitalName,
      'eq_department': widget.eqdepart,
      'eq_ward': widget.eqward,
      'eq_pic': widget.selectedUserName,
      'eq_class': widget.selectedEquipmentClass,
      'eq_type': widget.selectedEquipmentType,
      'email': widget.selectedUserEmail,
      'name': widget.selectedUserName,
      'date': widget.formattedDate,
      'nextdate': nextYearDate1,
      'ref_id': refId, // Use the value of refId
    };

    var res = await CallApi().addEquip(data, 'addEquip');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Equipment created Successfully.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => vendorMain()),
      );
    } else {
      Fluttertoast.showToast(
        msg: getVal['message'] ?? "Equipment failed to create.",
      );
    }
  }
}
