import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteNotification {
  static Future<void> delete(String notificationID) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_notification.php'),
          body: {'notification_id': notificationID});

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete: $e');
    }
  }
}
