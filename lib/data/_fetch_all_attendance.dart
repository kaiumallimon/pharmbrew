import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchAllAttendance{
  static Future<List<dynamic>> fetch()async{
    try{
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_all_attendance.php'),body: {
            'today': "${DateTime.now().toString().split(' ')[0]}"
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }
}

void main() async{
  List data=await FetchAllAttendance.fetch();
  print(data);
}