import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CallApi/CallApi.dart';
import 'auth/login.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
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
  String email='';
  String password='';
  String cpassword='';
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
                      "Reset Password",
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    onChanged: (val){
                      password=val;
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
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
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
                          'Reset Password',
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
                                _resetPassword();
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

  _resetPassword() async{
    final pref = await SharedPreferences.getInstance();
    email=pref.getString('tempEmail')!;
    var data = {
      'email':email,
      'password':password,
    };

    if(password==cpassword){
      var res = await CallApi().resetPassword(data,'resetpassword');
      var getVal = json.decode(res.body);

      if (getVal['success']){
        Fluttertoast.showToast(msg: "Password Reset Successful.");
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
