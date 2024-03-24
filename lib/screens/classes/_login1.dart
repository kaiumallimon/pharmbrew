import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/general/_login1_ui.dart';

class Login1 extends StatelessWidget {
  const Login1({super.key, required this.country});
  final String country;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Login1Ui(
        country: country,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
