import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchOrders{
  static Future<dynamic> fetch() async{
    try{
     var response = await http.get(Uri.parse('https://bcrypt.site/scripts/php/get_order_info.php'));
      if(response.statusCode == 200){
        return json.decode(response.body);
      }else{
        throw Exception('Failed to load data');
      }
    }catch(e){
      print(e);
      throw Exception('Failed to load data');
    }
  }
}

void main() async{
  var data = await FetchOrders.fetch();
  print(data);
}
