import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePassword {
  static Future<bool> update(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/update_password.php'),
          body: {
            'email': email,
            'password': password,
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update password: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
}
