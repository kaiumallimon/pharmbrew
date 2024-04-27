import 'package:http/http.dart' as http;
import 'dart:convert';


class ReadMessageAdmin {
  static Future<Map<String,dynamic>> fetch(String id) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/read_admin.php'),
          body: {
            'id': id,
          }
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to Update: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to Update: $e');
    }
  }

}

void main(List<String> args) async {
  Map<String,dynamic> status=await ReadMessageAdmin.fetch('EMP20240414170416');
}


