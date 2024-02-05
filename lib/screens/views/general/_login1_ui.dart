import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/routes/_image_routes.dart';
import 'package:pharmbrew/screens/views/mobile/_login1_mobile.dart';
import 'package:pharmbrew/screens/views/web/_login_web.dart';
import 'package:pharmbrew/widgets/_custom_password_field.dart';

import '../../../widgets/_custom_button_with_logo.dart';
import '../../../widgets/_custom_textField.dart';
import '../../../widgets/_logo.dart';
import '../../../widgets/_sideImage.dart';
import '../../../widgets/_spacer.dart';
import '../../../widgets/_terms_policy.dart';

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
