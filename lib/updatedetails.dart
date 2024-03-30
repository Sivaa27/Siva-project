import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CallApi/CallApi.dart';
import 'NavPage.dart';


class updateDetails extends StatefulWidget {
  const updateDetails({Key? key}) : super(key: key);

  @override
  State<updateDetails> createState() => _updateDetailsState();
}

class _updateDetailsState extends State<updateDetails> {
  final _formKey =GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  bool validatePassword(String pass){
    String _password = pass.trim();

    if(pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }
  String getId='';
  String getMatrix='';
  String getPassword='';
  String name='';
  String matricnum='';
  String email='';
  String password='';
  String cpassword='';
  String getName='';
  String getEmail='';
  @override
  void initState()  {
    super.initState();
    // setName=UserSharedPreference.getName();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      _get();
      setState(() {
        build(context);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image:AssetImage(
                "assets/images/cbg.png"
            ),
            fit:BoxFit.cover,
            opacity: 0.3),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [

          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 35, top: 2),
                    child: const Text(
                      "Manage Account Details",
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: TextEditingController(text: getName),
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Name';
                      }
                      return val.length < 8 ? 'Minimum character length is 8' : null;

                    },
                    onChanged: (val){
                      name=val;
                    },
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

                      hintStyle: const TextStyle(color: Colors.white),
                      fillColor: Colors.grey.shade100,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: TextEditingController(text: getEmail),
                    validator: (val){
                      if (val== null || val.isEmpty){
                        return 'Please Enter Email';
                      }
                      var rx = RegExp("\b*@student\.uthm.edu.my\$",caseSensitive: false);
                      return rx.hasMatch(val) ? null : 'Invalid UTHM Email';
                    },
                    onChanged: (val){
                      email=val;
                    },
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
                        Icons.person_2,
                        color: Colors.white,
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Update Account',
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
                              if(_formKey.currentState!.validate()){
                                _update();
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
  _update() async {
    var data = {
      'name': name,
      'email': email,
      'matricNo':getMatrix,
      'password':getPassword,
    };

    var res = await CallApi().UpdateData(data, 'update');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      Fluttertoast.showToast(msg: "Account Updated Successfully.");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('studentMatrix', getMatrix);
      prefs.setString('name', name);
      prefs.setString('email',email);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavPage())
      );
    } else {
      Fluttertoast.showToast(msg: "Invalid Credentials.");
    }
  }
  _get() async {
    final prefs = await SharedPreferences.getInstance();
    getName = prefs.getString('name')!;
    getEmail=prefs.getString('email')!;
    getPassword=prefs.getString('password')!;
    getMatrix=prefs.getString('studentMatrix')!;
    getId=prefs.getString('id')!;
    // print(getName);
  }
}
