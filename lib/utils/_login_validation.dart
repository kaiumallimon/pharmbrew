// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future<bool> login_and_remember(
    String email, String password, BuildContext context) async {
  if (email == 'admin@gmail.com' && password == 'pharmabrewadmin') {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    return true;
  } else {
    var currentProtocol = window.location.protocol;
    var url = '$currentProtocol//bcrypt.site/scripts/php/login.php';

// Then use loginUrl in your XMLHttpRequest

    final response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success']) {
        // Login successful, do something
        // print('Login successful');
        // print('User: ${responseData['user']}');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        return true;
      } else {
        // // Login failed, display error message
        // print('Login failed: ${responseData['message']}');
        // // showCustomErrorDialog(${responseData['message']}, context)
        showCustomErrorDialog('${responseData['message']}', context);

        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      // throw Exception('Failed to load data');
      showCustomErrorDialog('failed to load data', context);
      throw Exception('Failed to load data');
    }
  }
}

Future<bool> login(String email, String password, BuildContext context) async {
  if (email == 'admin@gmail.com' && password == 'pharmabrewadmin') {
    return true;
  } else {
    var currentProtocol = window.location.protocol;
    var url = '$currentProtocol//bcrypt.site/scripts/php/login.php';

    final response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success']) {
        // Login successful, do something
        print('Login successful');
        print('User: ${responseData['user']}');

        return true;
      } else {
        // Login failed, display error message
        // print('Login failed: ${responseData['message']}');
        showCustomErrorDialog('${responseData['message']}', context);
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      showCustomErrorDialog('failed to load data', context);
      throw Exception('Failed to load data');
      // return false;
    }
  }
}

Future<bool?> isLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn");
}

Future<Map<String, dynamic>> loginValidation(
    String email, String password, BuildContext context) async {
  //remember session
  const adminLogin = "admin@gmail.com";
  const adminSecurity = "admin";

  if (email == adminLogin && password == adminSecurity) {
    return {
      "login": true,
      "response": "Login Successful",
      "email": adminLogin,
      "role": "administrator",
    };
  } else {
    var currentProtocol = window.location.protocol;
    var apiUrl =
        '$currentProtocol//bcrypt.site/scripts/php/pharmabrew_login.php';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      // no internal errors
      final Map<String, dynamic> responseData = json.decode(response.body);

      // print(responseData);

      if (responseData['success'] == true) {
        //login successful
        return {
          "login": true,
          "response": "Login Successful",
          "email": responseData['email'],
          "name": responseData['name'],
          "picture": responseData['profile_pic'],
          "role": responseData['role'],
        };
      } else {
        //login failed/user not found
        return {
          "login": false,
          "response": "User not found",
        };
      }
    } else {
      showCustomErrorDialog('failed to load data', context);
      throw Exception('Failed to load data');
    }
  }
}
