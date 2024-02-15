import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_login1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) async{
  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login1()));

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getKeys().contains("isLoggedIn")){
    prefs.setBool("isLoggedIn", false);
  }
}