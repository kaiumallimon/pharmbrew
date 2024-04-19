import 'dart:convert';
import 'package:http/http.dart' as http;

class DailyAnalyticsAttendanceFetcher {
  static Future<dynamic> fetch() async {
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_daily_analytics.php'));

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

  dynamic emp = await DailyAnalyticsAttendanceFetcher.fetch();
  print(emp);
}