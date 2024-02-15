import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'screens/classes/_login1.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Dashboard(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.light(
        background: Color(0xFF0D0F2F),
        primary: Color(0xFF7179FF),
        secondary: Color(0xFF8DDCAC),
        tertiary: Color(0xFFFFAE1A),
        surface: Colors.grey.shade300,
      )
    ),
  ));
}
