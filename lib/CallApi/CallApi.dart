import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:shared_preferences/shared_preferences.dart';



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



  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };



}