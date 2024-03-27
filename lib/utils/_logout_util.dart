import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_login1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Login1(
                country: "",
              )));

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getKeys().contains("isLoggedIn")) {
    prefs.setBool("isLoggedIn", false);
  }
}

void logoutClicked(BuildContext context) async {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Login1(
                country: "",
              )));

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getKeys().contains("isLoggedIn")) {
    prefs.setBool("isLoggedIn", false);
    if (prefs.getKeys().contains("loggedInUser") ||
        prefs.getKeys().contains("loggedInRole") ||
        prefs.getKeys().contains("loggedInUserName") ||
        prefs.getKeys().contains("loggedInUserProfilePic")) {
      prefs.remove("loggedInUser");
      prefs.remove("loggedInRole");
      prefs.remove("loggedInUserName");
      prefs.remove("loggedInUserProfilePic");
    }
  }
}
