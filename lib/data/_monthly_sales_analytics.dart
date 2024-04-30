import 'dart:convert';
import 'package:http/http.dart' as http;

class MonthlySales {
  static Future<List<dynamic>> fetch() async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_day_wise_sales.php'),
          body: {'month': '${DateTime.now().month}', 'year': '${DateTime.now().year}'});

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to load monthly sales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load monthly sales: $e');
    }
  }
}

void main() async {
  var result = await MonthlySales.fetch();
  print(result);
}
