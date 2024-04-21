import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoveUser {
  static Future<bool> remove(String userId) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_user.php'),
          body: {
            'userId': userId,
          });

      if (response.statusCode == 200) {
        var result=json.decode(response.body);
        return result['success'];
      } else {
        throw Exception('Failed to delete employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }
}
