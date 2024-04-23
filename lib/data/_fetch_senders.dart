import 'package:http/http.dart' as http;
import 'dart:convert';


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



