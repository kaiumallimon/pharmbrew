import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchCurrentMonthAttendance{
  static Future<List<dynamic>> fetch(String userId) async{
    try{
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_current_month.php'),body: {
        'userId': userId,
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
  List data=await FetchCurrentMonthAttendance.fetch('EMP20240421155706');
  data.sort((a,b)=>a['date'].compareTo(b['date']));
  print(data);
}