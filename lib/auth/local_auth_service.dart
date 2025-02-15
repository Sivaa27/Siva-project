import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuth{

  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async=>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async{
    try{
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: const[
          AndroidAuthMessages(
            signInTitle: 'Sign in',
            cancelButton: 'No Thanks',
          )
        ],
        localizedReason: 'Use Fingerprint',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
        ),
      );
    } catch (e){
      debugPrint('error $e');
      return false;
    }
  }
}