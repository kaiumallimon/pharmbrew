import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) async{
  Navigator.pop(context);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getKeys().contains("isLoggedIn")){
    prefs.setBool("isLoggedIn", false);
  }
}