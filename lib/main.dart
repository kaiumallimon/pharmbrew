import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'package:pharmbrew/screens/classes/_login1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized before accessing SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? result = prefs.getBool("isLoggedIn");
  prefs.setBool("remembered", false);
  runApp(MyApp(result: result));
}

class MyApp extends StatelessWidget {
  final bool? result;

  const MyApp({Key? key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamilyFallback: const ["sans-serif", "monospace"],
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.light(
          background: const Color(0xFF0D0F2F),
          primary: const Color(0xFF7179FF),
          secondary: const Color(0xFF8DDCAC),
          tertiary: const Color(0xFFFFAE1A),
          surface: Colors.grey.shade300,
        ),
      ),
      home: result != null && result! ? const Dashboard() : const Login1(),
    );
  }
}
