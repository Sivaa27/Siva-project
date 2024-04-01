import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ppm/vendor_main.dart';
import 'CallApi/CallApi.dart';



class newHospital extends StatefulWidget {
  const newHospital({super.key});

  @override
  State<newHospital> createState() => _newHospitalState();
}

class _newHospitalState extends State<newHospital> {
  final _formKey = GlobalKey<FormState>();
  String name = '';

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch hospitals


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
                          "Add new Hospital",
                          style: TextStyle(color: Colors.white, fontSize: 33),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        validator: (val){
                          if (val==null || val.isEmpty){
                            return 'Please Enter Hospital Name';
                          }
                          return val.length < 8 ? 'Minimum character length is 8' : null;
                        },
                        onChanged: (val){
                          name=val;
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
                          hintText: 'Hospital Name',
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
                      // Register button...
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create Hospital Entry',
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
                                  _addHospital();
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
  _addHospital() async{
    Fluttertoast.showToast(msg: "Please Wait");
    var data = {
      'hosp_name':name,

    };

    var res = await CallApi().addHospital(data,'addHospital');
    var getVal = json.decode(res.body);

    if (getVal['success']){
      Fluttertoast.showToast(msg: "Hospital created Successfully.");
      Navigator.push(context,
          MaterialPageRoute(builder:(context)=>vendorMain())
      );
    }else{
      Fluttertoast.showToast(msg: getVal['message'] ?? "Hospital failed to create.");
    }
  }
}
