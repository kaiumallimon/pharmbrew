import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_file.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

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