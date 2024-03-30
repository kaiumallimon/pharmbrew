import 'package:http/http.dart' as http;

Future<bool?> addProduct({
  required String productName,
  required String variant,
  required String productionDate,
  required String unitPrice,
  required String expDate,
  required String quantity,
  required String unitPerStrips,
}) async {



  const String url =
      'https://bcrypt.site/scripts/php/add_products.php'; // Replace with your PHP script URL

  final response = await http.post(Uri.parse(url), body: {
    'productName': productName,
    'variant': variant,
    'productionDate': productionDate,
    'unitPrice': unitPrice,
    'expDate': expDate,
    'quantity': quantity,
    'unitPerStrips': unitPerStrips,
  });

  if (response.statusCode == 200) {
    // print('Product added successfully');
    return true;
  } else {
    return false;
  }
}
