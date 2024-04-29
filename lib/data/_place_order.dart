import 'dart:convert';

import 'package:http/http.dart' as http;

class PlaceOrder {
  static Future<bool> place(dynamic cart, dynamic customerInfo, String userId, String userName) async {
    List<dynamic> orderDetails = [];
    for (var item in cart) {
      orderDetails.add({
        'product_id': item['product_id'],
        'quantity': item['quantity (strips)'],
        'orderDate':
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        'price': item['price'],
      });
    }

    Map<String, dynamic> customerData = {
      'name': customerInfo['name'],
      'email': customerInfo['email'],
      'phone': customerInfo['phone'],
      'address': customerInfo['billing'],
      'employeeId': userId,
      'employeeName': userName,
      'orderdetails': orderDetails,
    };

    try {
      var response = await http.post(
        Uri.parse('https://bcrypt.site/scripts/php/order.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(customerData),
      );

      if (response.statusCode == 200) {
        var result= jsonDecode(response.body);
        return result['success'];
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }
}
