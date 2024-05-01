import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesInLast24h{
  static Future<Map<String,dynamic>> fetch() async{
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/sales_in_last_24h.php'));

      if (response.statusCode == 200) {
        var result=json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to load last 24h sales data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load last 24h sales data: $e');
    }
  }
}

void main() async{
  var result=await SalesInLast24h.fetch();
  print(result);
}
