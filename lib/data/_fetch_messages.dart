import 'package:http/http.dart' as http;
import 'dart:convert';

import '_fetch_senders.dart';

class FetchMessages {
  static Future<List<dynamic>> fetch(String userId) async {
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
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}


void main() async{
  List<dynamic> senders = await FetchSenders.fetchEmployee();
  List<String> senderIDs = [];

  for (var sender in senders) {
    senderIDs.add(sender['sender_id']);
  }

  print(senderIDs);
  List<dynamic> messages = [];

  for(var senderID in senderIDs) {
    messages = await FetchMessages.fetch(senderID);
  }

  print(messages);
}