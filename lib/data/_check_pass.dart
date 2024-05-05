import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckPassword {
  static Future<Map<String, dynamic>> check(
      String userId, String password) async {
    try {
      var response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/check_password.php'),
          body: {
            'userid': userId,
            'password': password,
          });

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return json.decode(response.body);
      }else{
        throw Exception('Failed to check password: ${response.statusCode}');
      }
    } catch (e) {

      throw Exception('Failed to check password: $e');

    }
  }
}


