import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchEmployee {
  static Future<List<dynamic>> fetchEmployee() async {
    try {
      final response = await http.post(
        Uri.parse('https://bcrypt.site/scripts/php/all_employee.php'),
      );

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

// void main(List<String> args) {
//   FetchEmployee.fetchEmployee().then((value) {
//     print(value);
//   }).catchError((error) {
//     print('Error: $error');
//   });
// }
