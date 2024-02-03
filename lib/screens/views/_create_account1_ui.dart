import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/routes/_image_routes.dart';
import 'package:pharmbrew/widgets/_custom_password_field.dart';

import '../../widgets/_custom_button_with_logo.dart';
import '../../widgets/_custom_textField.dart';
import '../../widgets/_logo.dart';
import '../../widgets/_sideImage.dart';
import '../../widgets/_spacer.dart';
import '../../widgets/_terms_policy.dart';

class CreateAccount1Ui extends StatelessWidget {
  const CreateAccount1Ui({super.key});

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Container(
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
                                const CustomTextField(
                                  label: 'Enter your email',
                                  icon: CupertinoIcons.mail,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const CustomPasswordField(
                                    label: 'Enter your password',
                                    icon: CupertinoIcons.lock),
                                const SizedBox(
                                  height: 10,
                                ),
                                const CustomButtonWithImageLogo(
                                  label: "Login",
                                  logo: '',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    or_margin(),
                                    Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: const Text('Or')),
                                    or_margin()
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomButtonWithImageLogo(
                                  label: "Continue with Google",
                                  logo: ImageRoutes.google,
                                )
                              ]),
                        )),

                        //last row
                        const Terms_Policy()
                      ]),
                    ),
                  )),

                  //right side of the page
                  Expanded(child: SideImageCol(dHeight: dHeight))
                ],
              ),

              //rightS
            ]),
          ),
        ],
      ),
    ));
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
