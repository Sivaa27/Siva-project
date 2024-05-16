import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


import '../CallApi/CallApi.dart';
import '../NavPage.dart';
import '../model/equipmentmodel.dart';

class serviceDetails extends StatefulWidget {
  final Equipment equipment;

  const serviceDetails({Key? key, required this.equipment}) : super(key: key);

  @override
  _serviceDetailsState createState() => _serviceDetailsState();
}

class _serviceDetailsState extends State<serviceDetails> {
  late TextEditingController _remarksController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _remarksController = TextEditingController();
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.equipment.nextdate);
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Issue'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ppmbg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipment: ${widget.equipment.eq_name}',
                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Serial Number: ${widget.equipment.eq_serial}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Manufacturer: ${widget.equipment.eq_manuf}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Hospital: ${widget.equipment.eq_hospital}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Department: ${widget.equipment.eq_department}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Ward: ${widget.equipment.eq_ward}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Class: ${widget.equipment.eq_class}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Type: ${widget.equipment.eq_type}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Last Service Date: ${widget.equipment.date}',
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _remarksController,
                  decoration: InputDecoration(
                    labelText: 'State the issue',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendReport,
                  child: Text('Submit Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendReport() async {
    var data = {
      'eq_name': widget.equipment.eq_name,
      'eq_serial': widget.equipment.eq_serial,
      'eq_manuf': widget.equipment.eq_manuf,
      'eq_hospital': widget.equipment.eq_hospital,
      'eq_department': widget.equipment.eq_department,
      'eq_ward': widget.equipment.eq_ward,
      'eq_pic': widget.equipment.eq_pic,
      'pic_email':widget.equipment.pic_email,
      'eq_class': widget.equipment.eq_class,
      'eq_type': widget.equipment.eq_type,
      'date': widget.equipment.date,
      'nextdate': widget.equipment.nextdate,
      'remarks': _remarksController.text,
      'vendor':widget.equipment.vendor,
    };

    var res = await CallApi().sendReport(data, 'sendreport');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Report Submitted Successfully.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavPage()),
      );
    } else {
      Fluttertoast.showToast(msg: "Failed to Submit Report.");
    }
  }
}
