
import 'package:http/http.dart' as http;

// Inside _EmployeesAllState class

Future<void> updateEmployeeRole(String employeeId, String newRole) async {
  try {
    var url = Uri.parse('https://bcrypt.site/scripts/php/update_role.php');



    var response = await http.post(
      url,
      body: {'userId': employeeId, 'newRole': newRole},
    );

    if (response.statusCode == 200) {
    } else {
    }
  } catch (e) {
  }
}
