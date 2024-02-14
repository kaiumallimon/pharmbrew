import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/utils/_login_click.dart';
import 'package:pharmbrew/widgets/_located_at.dart';

import '../../../routes/_image_routes.dart';
import '../../../widgets/_custom_button_with_logo.dart';
import '../../../widgets/_custom_password_field.dart';
import '../../../widgets/_custom_textField.dart';
import '../../../widgets/_logo.dart';
import '../../../widgets/_remember_forgot_pass.dart';
import '../../../widgets/_sideImage.dart';
import '../../../widgets/_spacer.dart';
import '../../../widgets/_terms_policy.dart';

class WebLogin extends StatelessWidget {
  WebLogin({super.key});

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: InteractiveViewer(
        minScale: 0.1,
          maxScale: 4.0,
        child: Column(
          children: [
            Expanded(
              child: Column(children: [
                //margin at the top
                pageTopSpace(),
        
                Row(
                  children: [
                    //left side of the page
        
                    //right side of the page
                    Expanded(child: SideImageCol(dHeight: dHeight)),
        
                    Expanded(
                        child: SizedBox(
                      height: dHeight - 45,
                      // color: Colors.red,
        
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(children: [
                          //first row
                          // ,
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Logo(),
                              LocatedAt(),
                            ],
                          ),
        
                          //second row
                          Expanded(
                              child: Container(
                            // color: Colors.red,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Login to your pharmabrew account',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  CustomTextField(
                                    label: 'Enter your email',
                                    icon: CupertinoIcons.mail,
                                    width: 350,
                                    height: 60,
                                    controller: _emailController,
                                  ),
        
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomPasswordField(
                                      controller: _passwordController,
                                      width: 350,
                                      height: 60,
                                      label: 'Enter your password',
                                      icon: CupertinoIcons.lock),
                                  const SizedBox(
                                    height: 10,
                                  ),
        
                                  const RememberAndForgotPassword(
                                    width: 350,
                                  ),
        
                                  const SizedBox(
                                    height: 10,
                                  ),
        
                                  CustomButtonWithImageLogo(
                                    label: "Login",
                                    logo: '',
                                    width: 350,
                                    height: 50,
                                    onClick: () {
                                      clickLogin(
                                          context,
                                          _emailController.text.toString().trim(),
                                          _passwordController.text
                                              .toString()
                                              .trim());
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
        
                                  Forgot_Password()
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     or_margin(),
                                  //     Container(
                                  //         width: 50,
                                  //         alignment: Alignment.center,
                                  //         child: const Text('Or')),
                                  //     or_margin()
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                  // CustomButtonWithImageLogo(
                                  //   label: "Continue with Google",
                                  //   logo: ImageRoutes.google,
                                  // )
                                ]),
                          )),
        
                          //last row
                          const Terms_Policy()
                        ]),
                      ),
                    )),
                  ],
                ),
        
                //rightS
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Container or_margin() {
    return Container(
      width: 150,
      height: 1,
      color: Colors.grey.shade300,
    );
  }

  SizedBox space5w() {
    return const SizedBox(
      width: 5,
    );
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
}
