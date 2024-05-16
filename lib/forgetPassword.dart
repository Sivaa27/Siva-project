import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppm/tokenVerify.dart';
import 'CallApi/CallApi.dart';
import 'NavPage.dart';
import 'auth/local_auth_service.dart';
import 'auth/login.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({Key? key}) : super(key: key);

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final _formKey =GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.\d)(?=.[a-z])(?=.[A-Z])(?=.\W)");
  bool validatePassword(String pass){
    String _password = pass.trim();

    if(pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }
  String name='';
  String matricnum='';
  String emailadd='';
  String password='';
  String cpassword='';
  String token='';
  bool isHTML = false;
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
                      "Reset your password",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                  SizedBox(height: 30,),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Verify your email to begin!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (val){
                      if (val== null || val.isEmpty){
                        return 'Please Enter Email';
                      }
                      var rx = RegExp(r'\b@\S+\.com\b', caseSensitive: false);
                      return rx.hasMatch(val) ? null : 'Invalid Email';
                    },
                    onChanged: (val){
                      emailadd=val;
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
                      hintText: 'Registered Email',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 3.3, vertical: 10)
                    ),
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        _verify();
                      }
                    },
                    child: Text(
                      'Send Code',
                      style: TextStyle(fontSize: 17,color: Colors.black),
                    ),
                  ),
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

  _verify() async{
    var data = {
      'email':emailadd,
    };
    print(emailadd);
    var res = await CallApi().VerifyEmail(data,'verify');
    var getVal = json.decode(res.body);

    if (getVal['success']){
      print("Success");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('tempEmail', emailadd);
      Fluttertoast.showToast(msg: "Please Wait");
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      token = code.toString();
      prefs.setString('token',token);
      _sendToken();
    }else{
      Fluttertoast.showToast(msg: "Email failed to be verified.");
    }


  }
  _sendToken() async{

    var data = {
      'email':emailadd,
      'token':token,
    };
    var data1 = {
      'email':emailadd,
    };
    var res = await CallApi().tokenUpdate(data,'token');
    var getVal = json.decode(res.body);

    var res1 = await CallApi().sendEmail(data1,'email');
    var getVal1 = json.decode(res.body);

    if (getVal['success']){
      Fluttertoast.showToast(msg: "Token Emailed.");
      Navigator.push(context,
          MaterialPageRoute(builder:(context)=>tokenVerify())
      );
    }else{
      Fluttertoast.showToast(msg: "Token failed to be verified. Please try again.");
    }

  }

}