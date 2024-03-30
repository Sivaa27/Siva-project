import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppm/resetPassword.dart';
import 'CallApi/CallApi.dart';


class tokenVerify extends StatefulWidget {
  const tokenVerify({Key? key}) : super(key: key);

  @override
  State<tokenVerify> createState() => _tokenVerifyState();
}

class _tokenVerifyState extends State<tokenVerify> {

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  String emailadd='';
  String pin1='';
  String token='';
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }
  @override
  void initState(){
    super.initState();
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
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.only(left: 35, top: 130),
            child: Text(
              "Verification Code",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter verification code which was sent to",textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white,
                ),),
                SizedBox(height: 10,),
                Text("$emailadd",textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.white,
                ),),
                SizedBox(height: 20,),
                OtpTextField(
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  filled: true,
                  keyboardType: TextInputType.number,
                  onSubmit: (otp){
                    print("OTP IS $otp");
                    pin1=otp;
                    _verify();
                  },
                ),
                const SizedBox(height: 20.0,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){},child: const Text("Next"),),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }


  _verify() async {
    var data = {
      'email': emailadd,
    };

    var res = await CallApi().verifyToken(data, 'verifytoken');
    var getVal = json.decode(res.body);

    if (getVal['success']) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', getVal['token']);
      token=prefs.getString('token')!;
      print("token value is");
      print("$token");
      if(token==pin1){
        Fluttertoast.showToast(msg: "Token Verified, please reset password.");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => resetPassword())
        );
      }
      else{
        Fluttertoast.showToast(msg: "Token failed to be verified.");
      }
    } else {
      Fluttertoast.showToast(msg: "Token failed to be verified.");
    }
  }

  _get() async{
    final prefs = await SharedPreferences.getInstance();
    emailadd = prefs.getString('tempEmail')!;

    // var data1 = {
    //   'email' :emailadd,
    // };
    //
    // var res1 = await CallApi().verifyToken(data1, 'verifytoken');

  }
}

