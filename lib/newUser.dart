import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ppm/vendor_main.dart';
import 'CallApi/CallApi.dart';
import 'model/hospitalmodel.dart';
import 'dart:math';

String _generatePassword() {
  const String specialChars = r'!@#$%^&*()-_=+[{]}|;:,<.>/?';
  const String upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowerCaseChars = 'abcdefghijklmnopqrstuvwxyz';
  const String numbers = '0123456789';

  String password = '';
  Random random = Random.secure();

  // Add one special character
  password += specialChars[random.nextInt(specialChars.length)];

  // Add one uppercase letter
  password += upperCaseChars[random.nextInt(upperCaseChars.length)];

  // Add one lowercase letter
  password += lowerCaseChars[random.nextInt(lowerCaseChars.length)];

  // Add one number
  password += numbers[random.nextInt(numbers.length)];

  // Fill the rest of the password with random characters from all sets
  for (int i = 0; i < 8; i++) {
    String charSet = specialChars + upperCaseChars + lowerCaseChars + numbers;
    password += charSet[random.nextInt(charSet.length)];
  }

  // Shuffle the characters in the password
  List<String> passwordCharacters = password.split('');
  passwordCharacters.shuffle();
  password = passwordCharacters.join('');

  return password;
}

class newUser extends StatefulWidget {
  const newUser({super.key});

  @override
  State<newUser> createState() => _newUserState();
}

class _newUserState extends State<newUser> {
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = false;
  String name = '';
  String email = '';
  String password = '';
  String passwordGenerated = 'Generate password';
  List<Hospital>? hospitals; // List to hold hospitals
  Hospital? selectedHospital; // Nullable selected hospital
  String role = 'User'; // Default role

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
                      top: MediaQuery.of(context).size.height * 0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 35, top: 2),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white, fontSize: 33),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return val.length < 8
                              ? 'Minimum character length is 8'
                              : null;
                        },
                        onChanged: (val) {
                          name = val;
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
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: 'Name',
                          hintStyle: const TextStyle(color: Colors.white),
                          fillColor: Colors.grey.shade100,
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please Enter Email';
                          }
                          var rx = RegExp(r'\b@\S+\.com\b', caseSensitive: false);
                          return rx.hasMatch(val) ? null : 'Invalid Email';
                        },
                        onChanged: (val) {
                          email = val;
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
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val == null || password.isEmpty) {
                                  return 'Please Generate Password';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                password = val;
                              },
                              style: TextStyle(color: Colors.white),
                              obscureText: obscurePassword,
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
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                hintText: passwordGenerated.isNotEmpty
                                    ? passwordGenerated
                                    : 'Password',
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                password = _generatePassword(); // Call function to generate password
                                print(password);
                                obscurePassword = false; // Show password temporarily
                                passwordGenerated = 'Password Generated';
                              });
                            },
                            child: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Role selection
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'User',
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Radio<String>(
                                value: 'User',
                                groupValue: role,
                                onChanged: (String? value) {
                                  setState(() {
                                    role = value!;
                                  });
                                },
                                activeColor: Colors.white,
                                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text(
                                'Vendor',
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Radio<String>(
                                value: 'Vendor',
                                groupValue: role,
                                onChanged: (String? value) {
                                  setState(() {
                                    role = value!;
                                  });
                                },
                                activeColor: Colors.white,
                                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Conditionally show the hospital dropdown
                      if (role == 'User')
                        hospitals == null
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<Hospital>(
                              value: selectedHospital,
                              onChanged: (Hospital? newValue) {
                                setState(() {
                                  selectedHospital = newValue;
                                });
                              },
                              items: hospitals!.map<DropdownMenuItem<Hospital>>((Hospital value) {
                                return DropdownMenuItem<Hospital>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
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
                                hintText: 'Select Hospital',
                                hintStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Can't find your hospital? Add new hospital.",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      // Register button...
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create Account',
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

  // Register function...
  _register() async {
    Fluttertoast.showToast(msg: "Please Wait");
    String token = 'test';
    var data = {
      'name': name,
      'email': email,
      'hospital': role == 'Vendor' ? 'Vendor' : selectedHospital!.name, // Use selected hospital's name or 'Vendor'
      'password': password,
      'token': token,
    };

    var res = await CallApi().RegisterData(data, 'register');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Account created Successfully.");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => vendorMain()));
    } else {
      Fluttertoast.showToast(msg: getVal['message'] ?? "Account failed to create.");
    }
  }
}
