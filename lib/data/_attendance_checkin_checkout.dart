import 'dart:convert';
import 'package:http/http.dart' as http;

class TakeAttendance{
  static Future<bool> checkIn(String userId, String date, String checkInTime, String status) async{
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_checkin.php'),
              body: {
                'userId': userId,
                'date': date,
                'checkInTime': checkInTime,
                'status': status
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


  static Future<bool> checkout(String userId, String date, String checkOutTime) async{
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_checkout.php'),
          body: {
            'userId': userId,
            'date': date,
            'checkoutTime': checkOutTime,
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