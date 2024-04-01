import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'CallApi/CallApi.dart';
import 'auth/login.dart';
import 'model/hospitalmodel.dart';
import 'model/userHospital.dart';
import 'package:intl/intl.dart';

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
  String eqhosp = '';
  String eqdepart = '';
  String eqward = '';
  String eqpic = '';
  String eqclass = '';
  String eqtype = '';
  List<Hospital>? hospitals; // List to hold hospitals
  Hospital? selectedHospital; // Nullable selected hospital
  List<String> equipmentClasses = [
    'Class 1',
    'Class 2',
    'Class 3'
  ]; // Equipment classes options
  String? selectedEquipmentClass; // Selected equipment class
  List<userHospital> users = []; // List to hold users
  userHospital? selectedUser; // Selected user
  // Define the equipment types options
  List<String> equipmentTypes = ['Type B', 'Type BF', 'Type CF'];
  String? selectedEquipmentType;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _fetchHospitals(); // Fetch hospitals when widget initializes
  }

  // Function to fetch hospitals
  void _fetchHospitals() async {
    List<Hospital> fetchedHospitals = await CallApi.getHospital();
    setState(() {
      hospitals = fetchedHospitals;
    });
  }

  // Function to fetch users based on selected hospital
  void _fetchUsers(String hospital) async {
    try {
      // Make API call to get users
      List<userHospital> fetchedUsers = await CallApi.getUserHospital(hospital);
      setState(() {
        users = fetchedUsers;
        selectedUser = null; // Reset selected user when fetching new users
      });
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error fetching users: $e');
      // Show an error message to the user
      Fluttertoast.showToast(
          msg: 'Error fetching users. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cbg.png"),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 35, top: 2),
                        child: const Text(
                          "Add new Equipment",
                          style: TextStyle(color: Colors.white, fontSize: 33),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Equipment Description', // Explanation of the equipment name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintText: 'Equipment Name',
                              hintStyle: const TextStyle(color: Colors.white),
                              fillColor: Colors.grey.shade100,
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ), // Equipment Name
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                        style: TextStyle(color: Colors.white),
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Icons.card_membership,
                            color: Colors.white,
                          ),
                          hintText: 'Equipment Serial Num',
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      ), // Equipment Serial
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Manufacturer';
                          }
                        },
                        onChanged: (val) {
                          eqmanuf = val;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintText: 'Equipment Manufacturer',
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      ), // Equipment Manufacturer
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PPM Date', // Explanation of the date
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            enabled: false, // Make it non-editable
                            initialValue:
                                formattedDate, // Set the initial value to today's date
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              hintText: 'Today\'s Date',
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      hospitals == null
                          ? Center(
                              child:
                                  CircularProgressIndicator()) // Show a loading indicator while hospitals are being fetched
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assign Hospital and PIC', // Explanation of the hospital dropdown
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                DropdownButtonFormField<Hospital>(
                                  value: selectedHospital,
                                  onChanged: (Hospital? newValue) {
                                    setState(() {
                                      selectedHospital = newValue;
                                      // Fetch users based on selected hospital
                                      _fetchUsers(selectedHospital!.name);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a hospital';
                                    }
                                    return null;
                                  },
                                  items: hospitals!
                                      .map<DropdownMenuItem<Hospital>>(
                                          (Hospital value) {
                                    return DropdownMenuItem<Hospital>(
                                      value: value,
                                      child: Text(
                                        value.name,
                                        style: TextStyle(
                                          color: Colors
                                              .white, // Set text color to white
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.card_membership,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Select Hospital',
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    fillColor: Colors.grey.shade100,
                                  ),
                                  dropdownColor: Colors.black,
                                ),
                                const SizedBox(
                                    height: 30), // Equipment Hospital
                                users.isEmpty
                                    ? Center(child: CircularProgressIndicator())
                                    : IgnorePointer(
                                        ignoring: users.isEmpty,
                                        child: DropdownButtonFormField<
                                            userHospital>(
                                          value:
                                              selectedUser, // Set initial value to selected user
                                          onChanged: (userHospital? newValue) {
                                            setState(() {
                                              selectedUser =
                                                  newValue; // Update selected user
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select a user';
                                            }
                                            return null;
                                          },
                                          items: users.map<
                                                  DropdownMenuItem<
                                                      userHospital>>(
                                              (userHospital user) {
                                            return DropdownMenuItem<
                                                userHospital>(
                                              value: user,
                                              child: Text(
                                                user.name,
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // Set text color to white
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              borderSide: BorderSide.none,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.card_membership,
                                              color: Colors.white,
                                            ),
                                            hintText: 'Select User',
                                            hintStyle: const TextStyle(
                                                color: Colors.white),
                                            fillColor: Colors.grey.shade100,
                                          ),
                                          dropdownColor: Colors.black,
                                        ),
                                      ),
                              ],
                            ),
                      const SizedBox(height: 30), // User Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Equipment Type & Class', // Explanation of the equipment type and class
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
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
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.card_membership,
                                color: Colors.white,
                              ),
                              hintText: 'Select Equipment Class',
                              fillColor: Colors.grey.shade100,
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                            dropdownColor: Colors.black,
                          ),
                          const SizedBox(height: 30), // Equipment Class
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
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.card_membership,
                                color: Colors.white,
                              ),
                              hintText: 'Select Equipment Type',
                              hintStyle: const TextStyle(color: Colors.white),
                              fillColor: Colors.grey.shade100,
                            ),
                            dropdownColor: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Equipment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _register();
                                }
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _register() async {
    String token = 'test';
    var data = {
      //'name':name,
      //'email':email,
      //'hospital':hospital,
      //'password':password,
      //'token':token,
    };

    if (eqhosp == eqclass) {
      var res = await CallApi().RegisterData(data, 'register');
      var getVal = json.decode(res.body);

      if (getVal['success']) {
        Fluttertoast.showToast(msg: "Account created Successfully.");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => loginScreen()),
        );
      } else {
        Fluttertoast.showToast(
          msg: getVal['message'] ?? "Account failed to create.",
        );
      }
    } else {
      Fluttertoast.showToast(msg: "Password doesn't match.");
    }
  }
}
