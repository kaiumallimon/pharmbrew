import 'package:http/http.dart' as http;
import 'dart:convert';

import '_fetch_senders.dart';

class FetchMessages {
  static Future<dynamic> fetch(String userId) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_message.php'),
          body: {
            'sender_id': userId,
          });

      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        return json.decode(response.body);

      } else {
        throw Exception('Failed to load Message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load employee Message: $e');
    }
  }
}


void main() async{
  dynamic senders = await FetchMessages.fetch('EMP20240319055204');
  print(senders);

}