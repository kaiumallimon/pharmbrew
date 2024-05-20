import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchPrivateFiles{
  static Future<dynamic>  getPrivateFile(String id) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_private_files.php'),
          body: {
            'id': id,
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