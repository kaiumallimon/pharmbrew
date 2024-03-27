// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/views/mobile/_login1_mobile.dart';
import 'package:pharmbrew/screens/views/web/_login_web.dart';

import '../web/_login_web2.dart';


class Login1Ui extends StatelessWidget {
  const Login1Ui({super.key, required this.country});
  final String country;
  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: (dWidth>600)?
        WebLogin(
          country:country
        ):
        MobileLogin1(country:country));
  }

  
}
