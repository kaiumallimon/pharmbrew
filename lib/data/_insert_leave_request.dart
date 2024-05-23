import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertLeaveRequest {
  static Future<bool> request(String userId, String type, String start,
      String end, String reason) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/leave_request.php'),
          body: {
            "userId": userId,
            "leave_type": type,
            "start_date": start,
            "end_date": end,
            "reason": reason
          });

      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        return true;
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}
