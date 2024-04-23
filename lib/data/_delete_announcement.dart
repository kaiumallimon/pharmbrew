import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAnnouncement {
  static Future<bool> delete(String announcementId) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_announcement.php'),
          body: {'announcement_id': announcementId});

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

