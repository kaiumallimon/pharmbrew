import 'package:http/http.dart' as http;
import 'package:pharmbrew/data/_fetch_admins.dart';
import 'dart:convert';

import 'package:pharmbrew/data/_fetch_employee_data.dart';

class FetchSenders {
  static Future<List<dynamic>> fetchEmployee() async {
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/get_senders.php'));

      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}



