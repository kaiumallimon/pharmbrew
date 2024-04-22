import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pharmbrew/data/_fetch_employee_data.dart';
import 'package:pharmbrew/data/_fetch_senders.dart';

class DeleteProduct {
  static Future<bool> delete(String name, String variant) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/delete_product.php'),
          body: {'productName': name, 'variant': variant});

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
  bool emp = await DeleteProduct.delete('Maxpro', '40mg');
  print(emp);
}
