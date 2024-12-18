import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmbrew/screens/views/general/_dashboard_ui.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.isAdministrator});
  bool isAdministrator;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return DashboardUi(
      isAdministrator: isAdministrator,
    );
  }
}
