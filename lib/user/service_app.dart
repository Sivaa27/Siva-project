import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ppm/user/service_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../EquipmentDetailsPage.dart';
import '../model/equipmentmodel.dart';

class serviceApp extends StatefulWidget {
  const serviceApp({super.key});

  @override
  State<serviceApp> createState() => _serviceAppState();
}

class _serviceAppState extends State<serviceApp> {
  late TextEditingController _searchController;
  String getEmail='';
  List<dynamic> _equipments = [];

  @override
  void initState() {
    super.initState();
    _get();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String keyword) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/filteredlist'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'keyword': keyword,
        'email': getEmail, // Pass the user's email to the backend
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _equipments = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load equipments');
    }
  }

  Color getColorBasedOnDate(String nextDate) {
    DateTime next = DateTime.parse(nextDate);
    DateTime now = DateTime.now();
    // Difference in days
    int difference = next.difference(now).inDays;
    if (difference <= 30) {
      return Colors.red;
    }
    return Colors.white;
  }

  void _showDetails(BuildContext context, Equipment equipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => serviceDetails(equipment: equipment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Equipment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter keyword',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String keyword = _searchController.text.trim();
                if (keyword.isNotEmpty) {
                  try {
                    await _performSearch(keyword);
                    if (_equipments.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Search Results'),
                            content: Text('No equipments found.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Search Results'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                itemCount: _equipments.length,
                                itemBuilder: (context, index) {
                                  Equipment equipment = Equipment.fromJson(_equipments[index]);
                                  Color cardColor = getColorBasedOnDate(equipment.nextdate);
                                  return Card(
                                    color: cardColor,
                                    child: ListTile(
                                      title: Text(equipment.eq_name),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Equipment Name: ${equipment.eq_name}"),
                                          Text("Serial Number: ${equipment.eq_serial}"),
                                          Text("Manufacturer: ${equipment.eq_manuf}"),
                                          Text("Hospital: ${equipment.eq_hospital}"),
                                          Text("Department: ${equipment.eq_department}"),
                                          Text("Ward: ${equipment.eq_ward}"),
                                          Text("PIC: ${equipment.eq_pic}"),
                                          Text("Class: ${equipment.eq_class}"),
                                          Text("Type: ${equipment.eq_type}"),
                                          Text("Last Date: ${equipment.date}"),
                                          Text("Next Date: ${equipment.nextdate}"),
                                        ],
                                      ),
                                      onTap: () {
                                        _showDetails(context, equipment);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                } else {
                  // Show a message to the user that the search field cannot be empty
                }
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  _get() async {
    final prefs = await SharedPreferences.getInstance();
    getEmail = prefs.getString('email')!;
    print(getEmail);
  }
}
