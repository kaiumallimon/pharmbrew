import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  const WebLogin({super.key});

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //logo
                            const Logo(),
                            Row(
                              children: [
                                Text(
                                  "I'm Located in",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                                space5w(),
                                Image.asset(
                                  ImageRoutes.bd_flag,
                                  scale: 2,
                                ),
                                space5w(),
                                const Text(
                                  "Bangladesh",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),

                        //second row
                        Expanded(
                            child: Container(
                          // color: Colors.red,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login to your pharmabrew account',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                CustomTextField(
                                  label: 'Enter your email',
                                  icon: CupertinoIcons.mail,
                                  width: 350,
                                  height: 60,
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                CustomPasswordField(
                                  width: 350,
                                  height: 60,
                                    label: 'Enter your password',
                                    icon: CupertinoIcons.lock),
                                SizedBox(
                                  height: 10,
                                ),

                                RememberAndForgotPassword(width: 350,),

                                SizedBox(
                                  height: 10,
                                ),

                                CustomButtonWithImageLogo(
                                  label: "Login",
                                  logo: '',
                                  width: 350,
                                  height: 50,
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                
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
}

