import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsentAttendance{
  static Future<bool> set(String userId, String date) async{
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_absent.php'),
          body: {
            'userId': userId,
            'date': date,
          }
      );

      if (response.statusCode == 200) {
        var result=json.decode(response.body);
        return result['success'];
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}

bool checkDate(String date){
  DateTime parsedDate = DateTime.parse(date);
  String formattedDate = "${parsedDate.year}-${parsedDate.month}-${parsedDate.day}";
  DateTime now = DateTime.now();
  String today = "${now.year}-${now.month}-${now.day}";
  return formattedDate == today;
}

void main(){
  print(checkDate('2024-04-19'));
}


