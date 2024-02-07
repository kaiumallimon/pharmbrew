import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/views/mobile/_login1_mobile.dart';
import 'package:pharmbrew/screens/views/web/_login_web.dart';


class CreateAccount1Ui extends StatelessWidget {
  const CreateAccount1Ui({super.key});

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: (dWidth>600)?WebLogin():MobileLogin1());
  }

  
}
