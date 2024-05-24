import 'package:http/http.dart' as http;

class DeleteMessage {
  static Future<void> delete(String messageID) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_message.php'),
          body: {'message_id': messageID});

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
