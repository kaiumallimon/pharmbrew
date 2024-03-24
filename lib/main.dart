import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_ip_api.dart';
import 'package:pharmbrew/domain/_get_location.dart';
import 'package:pharmbrew/screens/classes/_dashboard.dart';
import 'package:pharmbrew/screens/classes/_login1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? result = prefs.getBool("isLoggedIn");

  // Ensure 'remembered' key exists and set its value to false
  prefs.setBool("remembered", false);

  bool isAdministrator = prefs.getString("loggedInRole") == 'HR' ? true : false;
  String? country = await getCountry();
  print(country);
  runApp(MyApp(
    result: result,
    isAdministrator: isAdministrator,
    country: country!,
  ));
}

class MyApp extends StatelessWidget {
  final bool? result;
  final bool isAdministrator;
  final String country;

  const MyApp(
      {Key? key,
      this.result,
      required this.isAdministrator,
      required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamilyFallback: ["sans-serif", "monospace"], // No need for 'const'
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.light(
          background: const Color(0xFF0D0F2F),
          primary: const Color(0xFF7179FF),
          secondary: const Color(0xFF8DDCAC),
          tertiary: const Color(0xFFFFAE1A),
          surface: Colors.grey.shade300,
        ),
      ),
      home: result ?? false
          ? Dashboard(
              isAdministrator: isAdministrator,
            )
          : Login1(
              country: country,
            ),
    );
  }
}
