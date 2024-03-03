// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'package:pharmbrew/utils/_login_validation.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clickLogin(
    BuildContext context, String email, String password) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getBool("remembered")!) {
    //remembered
    if (await login_and_remember(email, password,context)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      showCustomErrorDialog("Wrong email/password", context);
    }
  } else {
    //not remembered
    if (await login(email, password,context)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } else {
      showCustomErrorDialog("Wrong email/password", context);
    }
  }
}
