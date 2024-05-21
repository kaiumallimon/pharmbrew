import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletePrivateFilesDatabase{
  static Future<void>  delete(String id, String fileName) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_private_file_database.php'),
          body: {
            'user': id,
            'fileName': fileName,
          });

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete: $e');
    }
  }
}