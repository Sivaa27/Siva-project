import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'QuestionnairePage.dart';
import 'CallApi/CallApi.dart';
import 'EquipmentDetailsPDF.dart';
import 'NavPage.dart';
import 'model/equipmentmodel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EquipmentDetailsPage extends StatefulWidget {
  final Equipment equipment;

  const EquipmentDetailsPage({Key? key, required this.equipment})
      : super(key: key);

  @override
  _EquipmentDetailsPageState createState() => _EquipmentDetailsPageState();
}

class _EquipmentDetailsPageState extends State<EquipmentDetailsPage> {
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
  late TextEditingController _commentsController; // Added
  late TextEditingController _performedByController; // Added
  late DateTime _selectedDate;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.equipment.eq_name);
    _serialController = TextEditingController(text: widget.equipment.eq_serial);
    _manufacturerController =
        TextEditingController(text: widget.equipment.eq_manuf);
    _hospitalController =
        TextEditingController(text: widget.equipment.eq_hospital);
    _departmentController =
        TextEditingController(text: widget.equipment.eq_department);
    _wardController = TextEditingController(text: widget.equipment.eq_ward);
    _picController = TextEditingController(text: widget.equipment.eq_pic);
    _classController = TextEditingController(text: widget.equipment.eq_class);
    _typeController = TextEditingController(text: widget.equipment.eq_type);
    _dateController = TextEditingController(text: widget.equipment.date);
    _nextDateController =
        TextEditingController(text: widget.equipment.nextdate);

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
    _commentsController.dispose(); // Added
    _performedByController.dispose(); // Added
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Equipment Name',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _serialController,
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: 'Manufacturer',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _hospitalController,
                decoration: InputDecoration(
                  labelText: 'Hospital',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _wardController,
                decoration: InputDecoration(
                  labelText: 'Ward',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _picController,
                decoration: InputDecoration(
                  labelText: 'PIC',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _classController,
                decoration: InputDecoration(
                  labelText: 'Class',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Type',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Last Date',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nextDateController,
                onTap: () =>
                    _selectDate(context), // Open date picker when tapped
                readOnly: true, // Make the text field read-only
                decoration: InputDecoration(
                  labelText: 'Next Date',
                  labelStyle: GoogleFonts.roboto(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _update();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to the QuestionnairePage
                      final selectedValues = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionnairePage()),
                      );

                      if (selectedValues != null) {
                        final questionnaireValues =
                        selectedValues['questionnaireValues'] as Map<String, String?>;
                        final remarks = selectedValues['remarks'] as Map<String, String>;

                        // Generate PDF with selected values from the questionnaire
                        await EquipmentDetailsPDF.generatePDF(
                          fileName: 'equipment_details.pdf',
                          nameController: _nameController,
                          serialController: _serialController,
                          manufacturerController: _manufacturerController,
                          hospitalController: _hospitalController,
                          departmentController: _departmentController,
                          wardController: _wardController,
                          picController: _picController,
                          classController: _classController,
                          typeController: _typeController,
                          dateController: _dateController,
                          nextDateController: _nextDateController,
                          questionnaireValues: questionnaireValues,
                          remarks: remarks, // Pass remarks here
                          comments: selectedValues['comments'], // Use selectedValues directly
                          performedBy: selectedValues['performedBy'],
                          context: context,
                        );
                        // Show a message to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('PDF generated successfully.'),
                          ),
                        );
                      }
                    },
                    child: Text('Generate PDF'),
                  ),
                ],
              ),
            ],
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
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
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
          _nextDateController.text =
              DateFormat('yyyy-MM-dd').format(_selectedDate);
        });
      }
    });
  }

  _update() async {
    var data = {
      'eq_name': _nameController.text,
      'eq_serial': _serialController.text,
      'eq_manuf': _manufacturerController.text,
      'eq_hospital': _hospitalController.text,
      'eq_department': _departmentController.text,
      'eq_ward': _wardController.text,
      'eq_pic': _picController.text,
      'eq_class': _classController.text,
      'eq_type': _typeController.text,
      'date': _dateController.text,
      'nextdate': _nextDateController.text,
      'eq_pic':widget.equipment.eq_pic,
      'vendor':widget.equipment.vendor,
      'ref_id':widget.equipment.ref_id,
      'pic_email':widget.equipment.pic_email,
    };

    var id = widget.equipment.id;
    var res = await CallApi().updateEquipment(data, 'updateEquip', id);
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Equipment Updated Successfully.");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavPage()));
    } else {
      Fluttertoast.showToast(msg: "Invalid Credentials.");
    }
  }
}
