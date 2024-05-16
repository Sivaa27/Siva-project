import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ppm/vendor_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddRefIdPage.dart';
import 'CallApi/CallApi.dart';
import 'auth/login.dart';
import 'model/hospitalmodel.dart';
import 'model/userHospital.dart';

class addEquip extends StatefulWidget {
  const addEquip({Key? key}) : super(key: key);

  @override
  State<addEquip> createState() => _addEquipState();
}

class _addEquipState extends State<addEquip> {
  final _formKey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String pass) {
    String _password = pass.trim();

    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  String eqname = '';
  String eqserial = '';
  String eqmanuf = '';
  String eqdepart = '';
  String eqward = '';
  List<Hospital>? hospitals;
  Hospital? selectedHospital;
  List<String> equipmentClasses = ['Class 1', 'Class 2', 'Class 3'];
  String? selectedEquipmentClass;
  List<userHospital> users = [];
  userHospital? selectedUser;
  List<String> equipmentTypes = ['Type B', 'Type BF', 'Type CF'];
  String? selectedEquipmentType;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? selectedUserEmail;
  String? selectedUserName;
  String? selectedHospitalName;
  String getEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchHospitals(); // Fetch hospitals when widget initializes
    _get(); // Call _get() to initialize getEmail
  }


  void _fetchHospitals() async {
    List<Hospital> fetchedHospitals = await CallApi.getHospital();
    setState(() {
      hospitals = fetchedHospitals;
    });
  }

  void _fetchUsers(String hospital) async {
    try {
      List<userHospital> fetchedUsers = await CallApi.getUserHospital(hospital);
      setState(() {
        users = fetchedUsers;
        selectedUser = null;
      });
    } catch (e) {
      print('Error fetching users: $e');
      Fluttertoast.showToast(
          msg: 'Error fetching users. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Equipment'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipment Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please Enter Equipment Name';
                    }
                    return val.length < 3
                        ? 'Minimum character length is 3'
                        : null;
                  },
                  onChanged: (val) {
                    eqname = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'Equipment Name',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please Enter Equipment Serial Num';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    eqserial = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'Equipment Serial Num',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please Enter Manufacturer';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    eqmanuf = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'Equipment Manufacturer',
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'PPM Date',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  initialValue: formattedDate,
                  decoration: InputDecoration(
                    labelText: 'Today\'s Date',
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<Hospital>(
                  value: selectedHospital,
                  onChanged: (Hospital? newValue) {
                    setState(() {
                      selectedHospital = newValue;
                      _fetchUsers(selectedHospital!.name);
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a hospital';
                    }
                    return null;
                  },
                  items: hospitals != null // Add a null check here
                      ? hospitals!
                      .map<DropdownMenuItem<Hospital>>((Hospital value) {
                    return DropdownMenuItem<Hospital>(
                      value: value,
                      child: Text(
                        value.name,
                      ),
                    );
                  })
                      .toList()
                      : [], // Return an empty list if hospitals is null
                  decoration: InputDecoration(
                    labelText: 'Select Hospital',
                  ),
                ),

                SizedBox(height: 20),
                DropdownButtonFormField<userHospital>(
                  value: selectedUser,
                  onChanged: (userHospital? newValue) {
                    setState(() {
                      selectedUser = newValue;
                      _updateSelectedUserEmail();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a user';
                    }
                    return null;
                  },
                  items: users
                      .map<DropdownMenuItem<userHospital>>((userHospital user) {
                    return DropdownMenuItem<userHospital>(
                      value: user,
                      child: Text(
                        user.name,
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Person-in-Charge',
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedEquipmentClass,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEquipmentClass = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a class';
                    }
                    return null;
                  },
                  items: equipmentClasses
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Equipment Class',
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedEquipmentType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEquipmentType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an equipment type';
                    }
                    return null;
                  },
                  items: equipmentTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select Equipment Type',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRefIDPage(
                                eqname: eqname,
                                eqserial: eqserial,
                                eqmanuf: eqmanuf,
                                eqdepart: eqdepart,
                                eqward: eqward,
                                selectedUserName: selectedUserName,
                                selectedHospitalName: selectedHospitalName,
                                selectedEquipmentClass: selectedEquipmentClass,
                                selectedEquipmentType: selectedEquipmentType,
                                selectedUserEmail: selectedUserEmail,
                                formattedDate: formattedDate,
                                vendor: getEmail,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateSelectedUserEmail() {
    setState(() {
      selectedUserEmail = selectedUser?.email;
      selectedUserName = selectedUser?.name;
      selectedHospitalName = selectedHospital?.name;
    });
  }

  _get() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if the key 'email' exists
    if (prefs.containsKey('email')) {
      getEmail = prefs.getString('email') ?? ''; // Use a default value if email is null
      print(getEmail);
    } else {
      // Handle the case where the email key does not exist
      print('Email key does not exist in SharedPreferences');
    }
  }

}
