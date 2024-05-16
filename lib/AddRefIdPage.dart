import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart'; // Import flutter_barcode_listener
import 'package:ppm/vendor_main.dart';

import 'CallApi/CallApi.dart';

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
  final String vendor;

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
    required this.vendor,
  }) : super(key: key);

  @override
  _AddRefIDPageState createState() => _AddRefIDPageState();
}

class _AddRefIDPageState extends State<AddRefIDPage> {
  String? _scannedRFID;
  DateTime currentDate = DateTime.now();
  String nextYearDate1 = '';
  String? _refId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateScannedRFID(String barcode) {
    setState(() {
      _scannedRFID = barcode;

      // Check if the length of the scanned barcode is equal to the expected length
      if (_scannedRFID != null && _scannedRFID!.length == 10) {
        _refId = _scannedRFID;
        print(_refId);
        // Display the message once the last value is scanned and completed
        Fluttertoast.showToast(
          msg: 'RFID scanned!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        _scannedRFID = null;
        _withRFIDScan();
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
            // Use the BarcodeKeyboardListener widget
            BarcodeKeyboardListener(
              bufferDuration: Duration(milliseconds: 200),
              onBarcodeScanned: _updateScannedRFID,
              useKeyDownEvent: true,
              child: Container(), // Dummy child widget
            ),
            Text(
              _scannedRFID ?? 'RFID not scanned yet',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: _skipRFIDScanning,
              child: Text('Skip RFID Scanning'),
            ),
          ],
        ),
      ),
    );
  }

  void _skipRFIDScanning() {
    DateTime nextYearDate =
    DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    nextYearDate1 = DateFormat('yyyy-MM-dd').format(nextYearDate);
    _submitFunction();
  }

  void _withRFIDScan() {
    DateTime nextYearDate =
    DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    nextYearDate1 = DateFormat('yyyy-MM-dd').format(nextYearDate);
    _submitwithRFIDFunction();
  }

  void _submitwithRFIDFunction() async {
    String? refId = _refId; // Use the value of _refId if it's set, otherwise use 'Not Set'

    var data = {
      'eq_name': widget.eqname,
      'eq_serial': widget.eqserial,
      'eq_manuf': widget.eqmanuf,
      'eq_hospital': widget.selectedHospitalName,
      'eq_department': widget.eqdepart,
      'eq_ward': widget.eqward,
      'eq_pic': widget.selectedUserName,
      'pic_email':widget.selectedUserEmail,
      'eq_class': widget.selectedEquipmentClass,
      'eq_type': widget.selectedEquipmentType,
      'email': widget.selectedUserEmail,
      'name': widget.selectedUserName,
      'date': widget.formattedDate,
      'nextdate': nextYearDate1,
      'ref_id': refId, // Use the value of refId
      'vendor':widget.vendor,
    };

    var res = await CallApi().addEquip(data, 'addEquip');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Equipment created Successfully.");
      Navigator.pushReplacementNamed(context, '/vendorMain'); // Navigate to vendorMain page and remove current page from the stack
    } else {
      Fluttertoast.showToast(
        msg: getVal['message'] ?? "Equipment failed to create.",
      );
    }
  }

  void _submitFunction() async {
    String refId = 'Not Set'; // Use the value of _refId if it's set, otherwise use 'Not Set'

    var data = {
      'eq_name': widget.eqname,
      'eq_serial': widget.eqserial,
      'eq_manuf': widget.eqmanuf,
      'eq_hospital': widget.selectedHospitalName,
      'eq_department': widget.eqdepart,
      'eq_ward': widget.eqward,
      'eq_pic': widget.selectedUserName,
      'pic_email':widget.selectedUserEmail,
      'eq_class': widget.selectedEquipmentClass,
      'eq_type': widget.selectedEquipmentType,
      'email': widget.selectedUserEmail,
      'name': widget.selectedUserName,
      'date': widget.formattedDate,
      'nextdate': nextYearDate1,
      'ref_id': refId, // Use the value of refId
      'vendor':widget.vendor,
    };

    var res = await CallApi().addEquip(data, 'addEquip');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Equipment created Successfully.");
      // Pop all other pages and push vendorMain
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => vendorMain(),
        ),
            (route) => false,//if you want to disable back feature set to false
      );
    } else {
      Fluttertoast.showToast(
        msg: getVal['message'] ?? "Equipment failed to create.",
      );
    }
  }
}
