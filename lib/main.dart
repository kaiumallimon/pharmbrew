import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'screens/classes/_login1.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login1(),
    theme: ThemeData(
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        background: Color(0xFF0D0F2F),
        primary: Color(0xFF7179FF),
        secondary: Color(0xFF8DDCAC),
        tertiary: Color(0xFFFFAE1A),
        surface: Colors.white,
      )
    ),
  ));
}
