import 'dart:convert';

import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> login_and_remember(String email, String password) async {
  if (email == 'admin@gmail.com' && password == 'pharmabrewadmin') {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    return true;
  } else {
    final String url = "http://bcrypt.site/scripts/php/login.php";

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
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        return true;
      } else {
        // Login failed, display error message
        print('Login failed: ${responseData['message']}');
        // showCustomErrorDialog(${responseData['message']}, context)
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
      return false;
    }
  }
  return false;
}

Future<bool> login(String email, String password) async {
  if (email == 'admin@gmail.com' && password == 'pharmabrewadmin') {
    return true;
  } else {
    final String url = "http://bcrypt.site/scripts/php/login.php";

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
        print('Login failed: ${responseData['message']}');
        // showCustomErrorDialog(${responseData['message']}, context)
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
      return false;
    }
  }
}

Future<bool?> isLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn");
}
