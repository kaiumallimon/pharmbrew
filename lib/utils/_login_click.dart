import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'package:pharmbrew/utils/_login_validation.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';

void clickLogin(BuildContext context, String email, String password){
  if(login(email, password)){
    Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
  }else{
    //error message dialog
    showCustomErrorDialog("Wrong email/password", context);
  }
}