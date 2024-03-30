import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ppm/auth/login.dart';
import 'package:ppm/password.dart';
import 'package:ppm/updatedetails.dart';


class manageAccount extends StatefulWidget {
  const manageAccount({Key? key}) : super(key: key);

  @override
  State<manageAccount> createState() => _manageAccountState();
}

class _manageAccountState extends State<manageAccount> {
  String getName='';
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
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Hello $getName!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white
                  )),
                  subtitle: Text('Good Day! You can manage your profile here!', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white54
                  )),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200)
                  )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Theme.of(context).primaryColor.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(CupertinoIcons.doc_person_fill, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('Update Details', style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context)=>updateDetails())
                      );
                    },),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Theme.of(context).primaryColor.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(CupertinoIcons.padlock, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('Change Password', style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context)=>passwordUpdate())
                      );
                    },),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Theme.of(context).primaryColor.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(CupertinoIcons.arrow_left_square_fill, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('Sign Out',
                            textAlign:TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,)
                        ],
                      ),
                    ),
                    onTap: (){
                      Fluttertoast.showToast(msg: "Signed Out Successfully!.");
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context)=>loginScreen())
                      );
                    },),

                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

  }

  _get() async {
    final prefs = await SharedPreferences.getInstance();
    getName = prefs.getString('name')!;
    prefs.setString('name', getName);
    // print(getName);
  }
}
