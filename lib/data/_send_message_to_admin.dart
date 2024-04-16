import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMessageToAdmin {
  static Future<List<dynamic>> send(String senderId,  String message) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/message_to_administrator.php'),
          body: {
            'sender_id': senderId,
            'message': message,
            'from': 'employee',
          });

      if (response.statusCode == 200) {
        return json.decode(response.body);

      } else {
        throw Exception('Failed to sendMessage: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}


// void main() async{
//   List<dynamic> senders = await SendMessages.toEmployee();
//   print(senders);
// }