import 'package:http/http.dart' as http;
import 'dart:convert';

import '_fetch_employee_data.dart';


class FetchAdminData {
  static Future<Map<String,dynamic>> fetch(String userId) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_admin_name.php'),
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


  static Future<String> getName(String id) async {
    String name='';
    await FetchEmployeeData.fetchEmployee(id).then((value) => name=value['name']);
    return name;
  }
}

main () async {
  print(await FetchEmployeeData.fetchEmployee('EMP20240319055204'));
}