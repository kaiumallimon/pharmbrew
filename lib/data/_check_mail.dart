import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckMail {
  static Future<bool> check(String email) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/check_mail.php'),
          body: {
            'email': email,
          });

      if (response.statusCode == 200) {
        var result= json.decode(response.body);

        return result['success'];
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}

void main(List<String> args) async {
}