import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppm/user/searchUserQuery.dart';
import 'package:ppm/user/service_app.dart';
import 'package:ppm/user/userNfcRead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../nfcread.dart';
import '../searchQuery.dart';

class userMain extends StatefulWidget {
  const userMain({super.key});

  @override
  State<userMain> createState() => _userMainState();
}

class _userMainState extends State<userMain> {
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
                  title: Text('Hello, $getName!', style: GoogleFonts.caveat(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white
                  ),),
                  subtitle: Text('Good Day!', style: GoogleFonts.caveat(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white
                  ),),

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
                              child: Icon(CupertinoIcons.doc_plaintext, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('Equipment Records', style: GoogleFonts.taiHeritagePro(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black))
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context)=>searchUserQuery())
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
                              child: Icon(CupertinoIcons.calendar_badge_plus, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('NFC Scanner',
                              textAlign:TextAlign.center,
                              style: GoogleFonts.taiHeritagePro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context)=>userNfcRead())
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
                              child: Icon(CupertinoIcons.clock, color: Colors.white)
                          ),
                          const SizedBox(height: 8),
                          Text('Service Application',
                              textAlign:TextAlign.center,
                              style: GoogleFonts.taiHeritagePro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                    onTap: (){
                       Navigator.push(context,
                           MaterialPageRoute(builder:(context)=>serviceApp())
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
