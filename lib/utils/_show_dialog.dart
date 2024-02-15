import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_error_dialog.dart';


void showCustomErrorDialog(String errorText, BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return ErrorDialog(errorMessage: errorText);
    }
  );
}