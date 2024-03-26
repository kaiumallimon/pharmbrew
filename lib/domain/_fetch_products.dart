import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://bcrypt.site/scripts/php/get_products.php'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}