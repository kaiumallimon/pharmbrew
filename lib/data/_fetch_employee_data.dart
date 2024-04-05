import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchEmployeeData {
  static Future<Map<String,dynamic>> fetchEmployee(String userId) async {
      try {
        final response = await http.post(
            Uri.parse('https://bcrypt.site/scripts/php/getUserInfo.php'),
            body: {
              'userId': userId,
            });

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load employees: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to load employees: $e');
      }
  }
}

// void main(List<String> args) async {
//   Map<String,dynamic> employeeData = await FetchEmployeeData.fetchEmployee('EMP20240326092142');
//   String id= employeeData['userId'];
//   String name= employeeData['name'];
//
//   print('ID: $id, Name: $name');
// }
