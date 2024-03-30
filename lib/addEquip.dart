import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'CallApi/CallApi.dart';
import 'auth/login.dart';

class addEquip extends StatefulWidget {
  const addEquip({super.key});

  @override
  State<addEquip> createState() => _addEquipState();
}

class _addEquipState extends State<addEquip> {
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
  String eqname='';
  String eqserial='';
  String eqmanuf='';
  String eqhosp='';
  String eqdepart='';
  String eqward='';
  String eqpic='';
  String eqclass='';
  String eqtype='';

  // String token='null';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        image: DecorationImage(
            image:AssetImage(
                "assets/images/cbg.png"
            ),
            fit: BoxFit.cover,
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
                      "Add new Equipment",
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Equipment Name';
                      }
                      return val.length < 8 ? 'Minimum character length is 3' : null;

                    },
                    onChanged: (val){
                      eqname=val;
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
                      hintText: 'Equipment Name',
                      hintStyle: const TextStyle(color: Colors.white),
                      fillColor: Colors.grey.shade100,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                    ),
                  ),//Equipment Name
                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Equipment Serial Num';
                      }
                      return null;
                    },
                    onChanged: (val){
                      eqserial=val;
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
                  ),//Equipment Serial
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (val){
                      if (val== null || val.isEmpty){
                        return 'Please Enter Manufacturer';
                      }

                    },
                    onChanged: (val){
                      eqmanuf=val;
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
                  ),//Equipment Manufacturer
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Hospital Name';
                      }
                      return null;
                    },
                    onChanged: (val){
                      eqhosp=val;
                    },
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
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
                        Icons.password,
                        color: Colors.white,
                      ),
                      hintText: 'Hospital Name',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),//Equipment Hospital
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Confirm Password';
                      }
                      else{
                        bool result=validatePassword(val);
                        if(result){
                          return null;
                        }
                        else{
                          return "Password should contain Uppercase, Lowercase, Number and Special Characters";
                        }
                      }

                    },
                    onChanged: (val){
                      cpassword=val;
                    },
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
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
                        Icons.password,
                        color: Colors.white,
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
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
                              if(_formKey.currentState!.validate()){
                                _register();
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

  _register() async{
    String token = 'test';
    var data = {
      'name':name,
      'email':email,
      'hospital':hospital,
      'password':password,
      'token':token,
    };

    if(password==cpassword){
      var res = await CallApi().RegisterData(data,'register');
      var getVal = json.decode(res.body);

      if (getVal['success']){
        Fluttertoast.showToast(msg: "Account created Successfully.");
        Navigator.push(context,
            MaterialPageRoute(builder:(context)=>loginScreen())
        );
      }else{
        Fluttertoast.showToast(msg: getVal['message'] ?? "Account failed to create.");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Password doesn't match.");
    }

  }
}
