import 'package:http/http.dart' as http;
import 'dart:convert';


class UpdateNotificationStatus {
  static Future<void> update(String id) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/update_notification_status.php'),
          body: {
            'notification_id': id,
          });

      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        var output= json.decode(response.body);
        if (output['success'] == 1) {
        } else {
        }
        // return output['success'];
      } else {
        throw Exception('Failed to update: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update : $e');
    }
  }
}


