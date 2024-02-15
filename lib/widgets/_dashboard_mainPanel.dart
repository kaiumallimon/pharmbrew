import 'package:flutter/cupertino.dart';

import '../screens/views/dash_ui/_add_employee.dart';
import '../screens/views/dash_ui/_analytics.dart';
import '../screens/views/dash_ui/_attendance.dart';
import '../screens/views/dash_ui/_dashboard_home.dart';
import '../screens/views/dash_ui/_employees.dart';
import '../screens/views/dash_ui/_events.dart';
import '../screens/views/dash_ui/_notifications.dart';
import '../screens/views/dash_ui/_profile.dart';
import '../screens/views/dash_ui/_queries_message.dart';
import '../screens/views/dash_ui/_roles.dart';
import '../screens/views/dash_ui/_salary_management.dart';
import '../screens/views/dash_ui/_settings.dart';

class DashboardMainPanel extends StatelessWidget {
  DashboardMainPanel({super.key, required this.inFocus});
  int inFocus;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: inFocus == 0
          ? const DashboardHome()
          : inFocus == 1
          ? const AddEmployee()
          : inFocus == 2
          ? const EmployeesAll()
          : inFocus == 3
          ? const EditProfile()
          : inFocus == 4
          ? const Notifications()
          : inFocus == 5
          ? const RolesAndAccess()
          : inFocus == 6
          ? const SalaryManagement()
          : inFocus == 7
          ? const Attendance()
          : inFocus == 8
          ? const Events()
          : inFocus == 9
          ? const Analytics()
          : inFocus == 10
          ? const Queries()
          : inFocus == 11
          ? const Settings()
          : Container(),
    );
  }
}