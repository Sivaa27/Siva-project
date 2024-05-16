import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CallApi/CallApi.dart';
import 'NavPage.dart';
import 'auth/local_auth_service.dart';

class passwordUpdate extends StatefulWidget {
  const passwordUpdate({Key? key}) : super(key: key);

  @override
  State<passwordUpdate> createState() => _passwordUpdateState();
}

class _passwordUpdateState extends State<passwordUpdate> {
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
  bool authenticated=false;
  String name='';
  String email='';
  String password='';
  String cpassword='';
  String getPassword='';
  String getName='';
  String getMatrix='';
  String getHospital='';

  @override

  void initState()  {
    super.initState();
    // setName=UserSharedPreference.getName();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      _get();
      _finger();
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
                      "Change Password",
                      style: TextStyle(color: Colors.white, fontSize: 33),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextFormField(
                    validator: (val){
                      if (val==null || val.isEmpty){
                        return 'Please Enter Current Password';
                      }
                      if(val!=getPassword){
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    onChanged: (val){
                      password=val;
                    },
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
                        Icons.person_2,
                        color: Colors.white,
                      ),
                      hintText: 'Current Password',
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                        Icons.person_2,
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
                        Icons.person_2,
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
                          'Change Password',
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
      'name': getName,
      'email': email,
      'password':password,
      'hospital':getHospital,
    };

    if(cpassword==password){

      var res = await CallApi().UpdateData(data, 'update');
      var getVal = json.decode(res.body);

      if (getVal['success']) {
        Fluttertoast.showToast(msg: "Password Updated Successfully.");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('password', password);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NavPage())
        );
      } else {
        Fluttertoast.showToast(msg: "Invalid Credentials.");
      }
    }

  }

  _finger() async{
    final authenticate = await LocalAuth.authenticate();
    setState(() {
      authenticated=authenticate;
      if(authenticated){
        print(authenticated);
      }
      else{
        Fluttertoast.showToast(msg: "Failed to validate.");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NavPage())
        );
      }
    });
  }
  _get() async {
    final prefs = await SharedPreferences.getInstance();
    getName = prefs.getString('name')!;
    getPassword=prefs.getString('password')!;
    email=prefs.getString('email')!;
    getHospital=prefs.getString('hospital')!;
    print("printing name below & password");
    print(getName);
    print(getPassword);
    print(getHospital);
    print(email);
    print("printing condition below");

  }
}
