import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ppm/CallApi/CallApi.dart';
import 'package:ppm/NavPage.dart';
import '../forgetPassword.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String getName = '';
  String getPassword = '';
  String getEmail='';
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  var buttonVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _get();
    });
  }

  Future<void> _authenticate() async {
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      authenticated = authenticated ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/cbg.png"),
            fit: BoxFit.cover,
            opacity: 0.3),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: Text(
              "Welcome,",
              style: GoogleFonts.sacramento(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.only(left: 35, top: 130),
            child: Text(
              "Sign in to continue",
              style: GoogleFonts.sacramento(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(children: [
                  TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      email = val;
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      password = val;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(40))),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Password',
                      labelStyle: TextStyle(color: Colors.purple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 85,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width / 6.3, vertical: 15)
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Forgot your password?",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 30, vertical: 10)
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => forgetPassword())
                            );
                          },
                          child: Text(
                            'Reset Password',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        )
                      ]),
                  Container(
                    child: Visibility(
                      visible: buttonVisible,
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await _authenticate();
                              if (authenticated) {
                                _loginwithPrint();
                              }
                            },
                            child: Text(
                              'Login as $getName',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _login() async {
    var data = {
      'email': email,
      'password': password,
    };

    var res = await CallApi().LoginData(data, 'login');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Account Login Successfully.");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('hospital', getVal['hospital']);
      prefs.setString('name', getVal['name']);
      prefs.setString('email', getVal['email']);
      prefs.setString('password', getVal['password']);
      prefs.setString('id', getVal['id'].toString());
      _get();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavPage()),
      );
    } else {
      Fluttertoast.showToast(msg: "Invalid Credentials.");
    }
  }

  _loginwithPrint() async {
    var data = {
      'email': getEmail,
      'password': getPassword,
    };

    var res = await CallApi().LoginData(data, 'login');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Account Login Successfully.");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('hospital', getVal['hospital']);
      prefs.setString('name', getVal['name']);
      prefs.setString('email', getVal['email']);
      prefs.setString('password', getVal['password']);
      prefs.setString('id', getVal['id'].toString());
      _get();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavPage()),
      );
    } else {
      Fluttertoast.showToast(msg: "Invalid Credentials.");
    }
  }

  _get() async {
    final prefs = await SharedPreferences.getInstance();
    getName = prefs.getString('name')!;
    getPassword = prefs.getString('password')!;
    getEmail = prefs.getString('email')!;
    setState(() {
      buttonVisible = getName.isNotEmpty && getPassword.isNotEmpty;
    });
  }
}
