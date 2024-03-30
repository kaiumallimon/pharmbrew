import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'package:pharmbrew/utils/_login_validation.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loginClicked(
    BuildContext context, String email, String password) async {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          height: 200,
          width: 400,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Logging in... Please wait...")
            ],
          ),
        ),
      ).frosted(
          blur: 50,
          frostColor: Colors.white,
          borderRadius: BorderRadius.circular(20));
    },
  );

  var responseData = await loginValidation(email, password, context);
  Navigator.pop(context); // Dismiss the loading dialog

  bool response = responseData['login'];
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isRemembered = preferences.getBool("remembered")!;
  if (response) {
    preferences.setString("loggedInUser", responseData['email']);
    preferences.setString("loggedInRole", responseData['role']);
    preferences.setString("loggedInUserName", responseData['name']);
    preferences.setString("loggedInUserProfilePic", responseData['picture']);


    if (isRemembered) {
      preferences.setBool("isLoggedIn", true);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                  isAdministrator:
                      responseData['role'].toString().trim() == 'HR')));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    isAdministrator: responseData['role'] == 'HR' ||
                        responseData['role'] == 'Administrator',
                  )));
    }
  } else {
    showCustomErrorDialog(responseData['response'], context);
  }
}
