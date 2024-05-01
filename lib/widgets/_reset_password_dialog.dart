import 'dart:async';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/main.dart';
import 'package:pharmbrew/screens/views/general/_login1_ui.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/widgets/_custom_textField.dart';
import 'package:flutter/cupertino.dart';

import '../data/_update_password.dart';
import '../domain/_mailer.dart';
import '../utils/_show_dialog2.dart';
import '_custom_button_with_logo.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  // late Timer timer1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        // elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        // leading: null,
        title: Text('Reset your password',
            style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            inProgress == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                          label: 'Enter your Email',
                          icon: CupertinoIcons.mail,
                          width: 350,
                          height: 60,
                          controller: emailController),
                    ],
                  )
                : inProgress == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                              label: 'Enter Verification Code',
                              icon: Icons.pin,
                              width: 350,
                              height: 60,
                              controller: verificationCodeController),
                        ],
                      )
                    : inProgress == 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomTextField(
                                      label: 'Enter New Password',
                                      icon: Icons.lock,
                                      width: 350,
                                      height: 60,
                                      controller: passwordController),
                                  const SizedBox(height: 20),
                                  CustomTextField(
                                      label: 'Confirm New Password',
                                      icon: Icons.lock,
                                      width: 350,
                                      height: 60,
                                      controller: confirmPasswordController),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButtonWithImageLogo(
                  label: "Continue",
                  logo: '',
                  width: 350,
                  height: 50,
                  onClick: () async {
                    if (inProgress == 0) {
                      if (emailController.text.toString().isNotEmpty &&
                          EmailValidator.validate(
                              emailController.text.toString())) {
                        setState(() {
                          inProgress = 1;
                          generatedCode = generateRandomCode();
                          emailGiven = emailController.text.toString();
                        });

                        sendEmail(
                            emailController.text.toString().trim(),
                            "Pharmabrew Password Reset Verification Code",
                            "Dear user,\nHere is your verification code: $generatedCode\n\nPlease enter this code to reset your password.\n\nThank you,\nPharmabrew Team");
                      } else {
                        showCustomErrorDialog(
                            'Please Enter a valid email address!', context);
                      }
                    } else if (inProgress == 1) {
                      if (verificationCodeController.text
                              .toString()
                              .isNotEmpty &&
                          verificationCodeController.text.toString() ==
                              generatedCode) {
                        setState(() {
                          inProgress = 2;
                        });
                      } else {
                        showCustomErrorDialog(
                            "Verification Code Didn't Matched!", context);
                      }
                    } else if (inProgress == 2) {
                      if (passwordController.text.toString().isNotEmpty &&
                          confirmPasswordController.text
                              .toString()
                              .isNotEmpty &&
                          passwordController.text.toString() ==
                              confirmPasswordController.text.toString()) {
                        setState(() {
                          inProgress = -1;
                        });

                        bool result = await UpdatePassword.update(
                            emailGiven, passwordController.text.toString());
                        if (result) {
                          showCustomSuccessDialog(
                              'Password Reset Successful!', context);
                        } else {
                          showCustomErrorDialog(
                              'Password Reset Unsuccessful!', context);
                        }

                        // Navigator.pop(context);
                      } else {
                        showCustomErrorDialog(
                            "Passwords didn't match!", context);
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  int inProgress = 0;

  late String generatedCode = '';
  late String emailGiven = '';

  String generateRandomCode() {
    Random random = Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    int randomNum = min + random.nextInt(max - min);
    return randomNum.toString();
  }
}
