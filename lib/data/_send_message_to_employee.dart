import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMessages {
  static Future<List<dynamic>> toEmployee(String senderId, String receiverId, String message) async {
    try {
      print('senderId: $senderId');
      print('receiverId: $receiverId');
      print('message: $message');

      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/message_to_employee.php'),
          body: {
            'sender_id': senderId,
            'receiver_id': receiverId,
            'message_content': message,
          });

      if (response.statusCode == 200) {
        return json.decode(response.body);

      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}


// void main() async{
//   List<dynamic> senders = await SendMessages.toEmployee();
//   print(senders);
// }