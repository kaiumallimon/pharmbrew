import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchEmployee {
  static Future<List<dynamic>> fetchEmployee(
      String? sortBy, String? sortOrder) async {
    if (sortBy != null && sortOrder != null) {
      //order given
      // print('Sorting based on $sortBy');
      // print("isEmpty: ${sortBy.isEmpty}");
      try {
        final response = await http.post(
            Uri.parse('https://bcrypt.site/scripts/php/all_employee.php'),
            body: {
              'sort-by': sortBy,
              'sort': sortOrder,
            });

        if (response.statusCode == 200) {
          // print(json.decode(response.body));
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load employees: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to load employees: $e');
      }
    } else {
      //order not given
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
}

void main() async {
  print(await FetchEmployee.fetchEmployee('rating', "DESC"));
}
