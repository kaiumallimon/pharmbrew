import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletePrivateFiles{
  static Future<dynamic>  delete(String id, String fileName) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_private_file.php'),
          body: {
            'id': id,
            'filename': fileName,
          });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete: $e');
    }
  }
}