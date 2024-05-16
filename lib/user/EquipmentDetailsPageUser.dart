import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/equipmentmodel.dart';

class EquipmentDetailsPageUser extends StatefulWidget {
  final Equipment equipment;

  const EquipmentDetailsPageUser({Key? key, required this.equipment}) : super(key: key);

  @override
  State<EquipmentDetailsPageUser> createState() => _EquipmentDetailsPageUserState();
}

class _EquipmentDetailsPageUserState extends State<EquipmentDetailsPageUser> {
  late TextEditingController _nameController;
  late TextEditingController _serialController;
  late TextEditingController _manufacturerController;
  late TextEditingController _hospitalController;
  late TextEditingController _departmentController;
  late TextEditingController _wardController;
  late TextEditingController _picController;
  late TextEditingController _classController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _nextDateController;
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment.eq_name);
    _serialController = TextEditingController(text: widget.equipment.eq_serial);
    _manufacturerController = TextEditingController(text: widget.equipment.eq_manuf);
    _hospitalController = TextEditingController(text: widget.equipment.eq_hospital);
    _departmentController = TextEditingController(text: widget.equipment.eq_department);
    _wardController = TextEditingController(text: widget.equipment.eq_ward);
    _picController = TextEditingController(text: widget.equipment.eq_pic);
    _classController = TextEditingController(text: widget.equipment.eq_class);
    _typeController = TextEditingController(text: widget.equipment.eq_type);
    _dateController = TextEditingController(text: widget.equipment.date);
    _nextDateController = TextEditingController(text: widget.equipment.nextdate);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.equipment.nextdate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialController.dispose();
    _manufacturerController.dispose();
    _hospitalController.dispose();
    _departmentController.dispose();
    _wardController.dispose();
    _picController.dispose();
    _classController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _nextDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Details'),
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
                TextFormField(
                  controller: _nameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Equipment Name',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _serialController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Serial Number',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _manufacturerController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Manufacturer',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _hospitalController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Hospital',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _departmentController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _wardController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Ward',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _picController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'PIC',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _classController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _typeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Last Date',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                TextFormField(
                  controller: _nextDateController,
                  onTap: () => _selectDate(context), // Open date picker when tapped
                  readOnly: true, // Make the text field read-only
                  decoration: InputDecoration(
                    labelText: 'Next Date',
                    labelStyle: GoogleFonts.roboto(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Method to open date picker
// Method to open date picker
  Future<void> _selectDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 300, // Set a fixed width for the container
            height: 400, // Set a fixed height for the container
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SfDateRangePicker(
                    initialSelectedDate: _selectedDate,
                    minDate: DateTime.now(),
                    maxDate: DateTime(2101),
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      if (args.value is DateTime) {
                        Navigator.pop(context, args.value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((pickedDate) {
      // Update the selected date if a date is selected
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate;
          _nextDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
        });
      }
    });
  }


}
