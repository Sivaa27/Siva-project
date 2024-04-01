import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:ppm/model/hospitalmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/userHospital.dart';



class CallApi{

  LoginData(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/login';
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }
  UpdateData(data,apiURL) async{
    String getId='';
    final pref=await SharedPreferences.getInstance();
    getId=pref.getString('id')!;
    String fullUrl = 'http://10.0.2.2:8000/api/update/'+getId;
    print(fullUrl);
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );

  }
  sendEmail(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/otp';
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }

  tokenUpdate(data,apiURL) async{
    String getToken='';
    String tempEmail='';
    final pref=await SharedPreferences.getInstance();
    getToken=pref.getString('token')!;
    tempEmail=pref.getString('tempEmail')!;
    String fullUrl = 'http://10.0.2.2:8000/api/token/'+tempEmail+'?'+getToken;
    print(fullUrl);
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );

  }

  resetPassword(data,apiURL) async{
    String password='';
    String tempEmail='';
    final pref=await SharedPreferences.getInstance();
    tempEmail=pref.getString('tempEmail')!;
    String fullUrl = 'http://10.0.2.2:8000/api/resetpassword/'+tempEmail+'?';
    print(fullUrl);
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );

  }

  RegisterData(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/register';

    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }


  VerifyEmail(data,apiURL) async{
    String getEmail='';
    final pref=await SharedPreferences.getInstance();
    getEmail=pref.getString('tempEmail')!;
    String fullUrl = 'http://10.0.2.2:8000/api/verify?email='+getEmail;
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }
  verifyToken(data,apiURL) async{
    String getEmail='';
    final pref=await SharedPreferences.getInstance();
    getEmail=pref.getString('tempEmail')!;
    String fullUrl = 'http://10.0.2.2:8000/api/verifytoken?email='+getEmail;
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }



  SubmitScore(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/score';

    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }




  SubmitBooking(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/book';

    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }
  SubmitApp(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/appbook';
    print("object");
    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }

  static Future<List<Hospital>> getHospital()async{

    final listurl = 'http://10.0.2.2:8000/api/hospitals';

    final response = await http.post(Uri.parse(listurl));
    final body = json.decode(response.body);
    // final pref = await SharedPreferences.getInstance();
    // pref.setStringList('cname',[body['name']]);
    //print('******');
    //print(body);
    //print(body.map<QuestionModel>(QuestionModel.fromJson).toList());
    print(body.map<Hospital>(Hospital.fromJson).toList());
    return body.map<Hospital>(Hospital.fromJson).toList();
  }
  addHospital(data,apiURL) async{
    String fullUrl = 'http://10.0.2.2:8000/api/addhospital';

    print(convert.jsonEncode(data));
    return await http.post(
        Uri.parse(fullUrl),
        body: convert.jsonEncode(data),
        headers: _setHeaders()
    );
  }
  static Future<List<userHospital>> getUserHospital(String selectedHospital) async {

    final listurl = 'http://10.0.2.2:8000/api/hospitaluser?hospital=' + selectedHospital;
    final response = await http.post(Uri.parse(listurl));
    final body = json.decode(response.body);

    // Check if the response body contains the 'data' key
    if (body.containsKey('data')) {
      // Parse the 'data' key
      final dataList = body['data'] as List;
      // Map each item in the list to your model
      List<userHospital> hospitals = dataList.map((e) => userHospital.fromJson(e)).toList();
      return hospitals;
    } else {
      // Handle error case when 'data' key is not found
      throw Exception('Data key not found in response');
    }
  }

  // static Future<List<userHospital>> getUserHospital(String selectedHospital) async {
  //   final url = 'http://10.0.2.2:8000/api/hospitaluser?hospital=$selectedHospital';
  //   print(url);
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final dynamic responseBody = json.decode(response.body);
  //     if (responseBody is List) {
  //       List<userHospital> users = responseBody.map((json) => userHospital.fromJson(json)).toList();
  //       return users;
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }






  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };




}