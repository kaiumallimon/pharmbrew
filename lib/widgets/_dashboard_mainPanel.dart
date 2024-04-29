import 'package:flutter/material.dart';
import 'package:pharmbrew/screens/views/dash_ui/_order_history.dart';
import 'package:pharmbrew/screens/views/dash_ui/_search_employee.dart';
import 'package:pharmbrew/screens/views/dash_ui/employee/_emp_announcements.dart';
import 'package:pharmbrew/screens/views/dash_ui/employee/_emp_edit_profile.dart';
import 'package:pharmbrew/screens/views/dash_ui/employee/_emp_home.dart';
import 'package:pharmbrew/screens/views/dash_ui/employee/_emp_inbox.dart';
import 'package:pharmbrew/screens/views/dash_ui/employee/emp_notification.dart';
import '../screens/views/dash_ui/_add_employee.dart';
import '../screens/views/dash_ui/_analytics.dart';
import '../screens/views/dash_ui/_attendance.dart';
import '../screens/views/dash_ui/_dashboard_home.dart';
import '../screens/views/dash_ui/_employees.dart';
import '../screens/views/dash_ui/_events.dart';
import '../screens/views/dash_ui/_notifications.dart';
import '../screens/views/dash_ui/_orders.dart';
import '../screens/views/dash_ui/_products.dart';
import '../screens/views/dash_ui/_queries_message.dart';
import '../screens/views/dash_ui/_roles.dart';
import '../screens/views/dash_ui/_salary_management.dart';
import '../screens/views/dash_ui/_settings.dart';
import '../screens/views/dash_ui/employee/_emp_leave_request.dart';
import '../screens/views/dash_ui/employee/_emp_products.dart';

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
                  // : inFocus == 3
                  //     ? const EditProfile()
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
                                                  : inFocus == 12
                                                      ? const EmployeeHome()
                                                      : inFocus == 13
                                                          ? const EmployeeEditProfile()
                                                          : inFocus == 14
                                                              ? const SearchEmployee()
                                                              : inFocus == 15
                                                                  ? const Products()
                                                                  : inFocus ==
                                                                          16
                                                                      ? const Orders()
                                                                      : inFocus ==
                                                                              17
                                                                          ? const EmployeeInbox()
                                                                          : inFocus == 18
                                                                              ? const EmployeeNotifications()
                                                                              : inFocus == 19
                                                                                  ? const EmployeeProducts()
                                                                                  : inFocus == 20
                                                                                      ? const EmployeeAnnouncement()
                                                                                      : inFocus == 21
                                                                                          ? const EmployeeLeaveRequest(): inFocus == 22
                                                                                          ? const OrderHistory()
                                                                                          : Container(),
    );
  }
}
