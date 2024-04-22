import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pharmbrew/data/_fetch_employee_data.dart';
import 'package:pharmbrew/data/_fetch_senders.dart';

class FetchAdmins {
  static Future<Map<String,dynamic>> fetch() async {
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/get_all_admins.php'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }

}


void main(){
  FetchAdmins.fetch().then((value) => print(value));
}

