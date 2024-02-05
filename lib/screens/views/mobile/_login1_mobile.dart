import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_custom_button_with_logo.dart';
import 'package:pharmbrew/widgets/_custom_password_field.dart';
import 'package:pharmbrew/widgets/_custom_textField.dart';
import 'package:pharmbrew/widgets/_logo.dart';
import 'package:pharmbrew/widgets/_remember_forgot_pass.dart';
import 'package:pharmbrew/widgets/_terms_policy.dart';

class MobileLogin1 extends StatelessWidget {
  const MobileLogin1({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Logo()],
          ),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to your \npharmabrew account',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  CustomTextField(
                      label: 'Enter your email address',
                      icon: CupertinoIcons.mail,
                      width: 300,
                      height: 60),
                  SizedBox(
                    height: 10,
                  ),
                  CustomPasswordField(
                      label: 'Enter your password',
                      icon: CupertinoIcons.lock,
                      width: 300,
                      height: 60),
                  SizedBox(
                    height: 5,
                  ),
                  RememberAndForgotPassword(width: 300),
                  CustomButtonWithImageLogo(
                    logo: "",
                    label: "Login",
                    width: 300,
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Forgot_Password(),
                  // SizedBox(height: 50,)
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
