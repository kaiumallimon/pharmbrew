import 'dart:convert';
import 'package:http/http.dart' as http;

class GetAttendance{
  static Future<List<dynamic>> get() async{
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/get_attendance.php'));

      if (response.statusCode == 200) {
        var result=json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}

void main(List<String> args) async {
  List<dynamic> attendance = await GetAttendance.get();
  print(attendance);
}