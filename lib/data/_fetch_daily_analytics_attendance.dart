import 'dart:convert';
import 'package:http/http.dart' as http;

class DailyAnalyticsAttendanceFetcher {
  static Future<dynamic> fetch(String date) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_daily_analytics.php'),
        body: {
          'currentDate': date,
        }
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }

}

main(List<String> args) async {
  String date=DateTime.now().toString().split(' ')[0];
  var data=await DailyAnalyticsAttendanceFetcher.fetch(date);
  print(data);
}