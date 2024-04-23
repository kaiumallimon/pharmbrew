import 'package:http/http.dart' as http;
import 'dart:convert';



class FetchAnnouncements {
  static Future<List<dynamic>> fetch() async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_announcements.php'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load: $e');
    }
  }
}

main () async {
}