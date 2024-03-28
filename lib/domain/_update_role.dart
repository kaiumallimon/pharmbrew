import 'dart:html';

import 'package:http/http.dart' as http;
import 'dart:convert';

// Inside _EmployeesAllState class

Future<void> updateEmployeeRole(String employeeId, String newRole) async {
  try {
    var currentProtocol=window.location.protocol;
    var url = Uri.parse('https://bcrypt.site/scripts/php/update_role.php');

    print('Sent Employee ID: $employeeId');
    print('Sent New Role: $newRole');


    var response = await http.post(
      url,
      body: {'userId': employeeId, 'newRole': newRole},
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
    } else {
      print('Failed to update role: ${response.statusCode}');
    }
  } catch (e) {
    print('Network error: $e');
  }
}
