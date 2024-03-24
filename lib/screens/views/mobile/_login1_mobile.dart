import 'package:flutter/cupertino.dart';
import 'package:pharmbrew/widgets/_custom_button_with_logo.dart';
import 'package:pharmbrew/widgets/_custom_password_field.dart';
import 'package:pharmbrew/widgets/_custom_textField.dart';
import 'package:pharmbrew/widgets/_located_at.dart';
import 'package:pharmbrew/widgets/_logo.dart';
import 'package:pharmbrew/widgets/_remember_forgot_pass.dart';

import '../../../utils/_login_click.dart';

class MobileLogin1 extends StatelessWidget {
  MobileLogin1({super.key, required this.country});
  final String country;

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
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LocatedAt(
                  country: country,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        Expanded(
          flex: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
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
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  CustomTextField(
                    label: 'Enter your email address',
                    icon: CupertinoIcons.mail,
                    width: 300,
                    height: 60,
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomPasswordField(
                    label: 'Enter your password',
                    icon: CupertinoIcons.lock,
                    width: 300,
                    height: 60,
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const RememberAndForgotPassword(width: 300),
                  CustomButtonWithImageLogo(
                    logo: "",
                    label: "Login",
                    width: 300,
                    height: 50,
                    onClick: () {
                      loginClicked(
                          context,
                          _emailController.text.toString().trim(),
                          _passwordController.text.toString().trim());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Forgot_Password(),
                  // SizedBox(height: 50,)
                ],
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
          height: 100,
        ))
      ],
    );
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
}
