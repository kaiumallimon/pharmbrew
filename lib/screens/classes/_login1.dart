import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmbrew/screens/views/general/_login1_ui.dart';

class Login1 extends StatelessWidget {
  const Login1({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark
    ));
    return Scaffold(
      body: const CreateAccount1Ui(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}