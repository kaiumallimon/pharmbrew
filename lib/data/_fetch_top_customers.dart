import 'dart:convert';
import 'package:http/http.dart' as http;

class TopCustomers{
  static Future<List<dynamic>> fetch() async{
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/top_five_customers.php'));

      if (response.statusCode == 200) {
        var result=json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to load top selling products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load top selling products: $e');
    }
  }
}

void main() async{
  var result=await TopCustomers.fetch();
  print(result);
}
