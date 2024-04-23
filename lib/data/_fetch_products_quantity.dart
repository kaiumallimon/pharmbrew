import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchProductsQuantity {
  static Future<dynamic> fetch(String name) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_product_quantity.php'),
          body: {
            'name': name,
          }
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load quantity: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load quantity: $e');
    }
  }

}

void main() async{
  String name='Napa Rapiddd - 500mg';
  var data= await FetchProductsQuantity.fetch(name);
}