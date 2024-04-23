import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAnnouncement {
  static Future<bool> create(String title, String description, String create_time, String creatorId, String start_date, String end_date) async {
    try {
      print('user_id: $creatorId ');
      final response = await http.post(
        Uri.parse('https://bcrypt.site/scripts/php/create_announcement.php'),
        body: {
          'title': title,
          'description': description,
          'create_time': create_time,
          'creator_id': creatorId,
          'start_date': start_date,
          'end_date': end_date
        },
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result['success'];
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}
