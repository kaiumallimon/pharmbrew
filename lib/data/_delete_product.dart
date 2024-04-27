import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteProduct {
  static Future<bool> delete(String productID) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_product.php'),
          body: {'productID': productID});

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result['success'];
      } else {
        throw Exception('Failed to load senders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load senders: $e');
    }
  }
}

main(List<String> args) async {
  // bool emp = await DeleteProduct.delete('Maxpro', '40mg');
}
