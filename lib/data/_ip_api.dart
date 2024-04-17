import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchIPInfo() async {
  try {
    final response = await http.get(Uri.parse('https://ipinfo.io/json?token=860f2164338588'));

    if (response.statusCode == 200) {
      // Check Content-Type to ensure it's JSON
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        // Parse JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        return {};
      }
    } else {
      return {};
    }
  } catch (e) {
    return {};
  }
}
