import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login_and_remember(String email, String password) async {

  if(email=='admin@gmail.com' && password=='pharmabrewadmin'){
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    return true;
  }
  return false;
}

Future<bool> login(String email, String password) async {

  if(email=='admin@gmail.com' && password=='pharmabrewadmin'){
    return true;
  }
  return false;
}

Future<bool?> isLoggedIn() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn");
}

