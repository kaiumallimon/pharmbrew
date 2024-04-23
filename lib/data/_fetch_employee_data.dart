import 'package:http/http.dart' as http;
import 'dart:convert';


class FetchEmployeeData {
  static Future<Map<String,dynamic>> fetchEmployee(String userId) async {
      try {
        final response = await http.post(
            Uri.parse('https://bcrypt.site/scripts/php/getUserInfo.php'),
            body: {
              'userId': userId,
            });

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load employees: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to load employees: $e');
      }
  }
}


String getName(String id){
  String name='';
  FetchEmployeeData.fetchEmployee(id).then((value) => name=value['name']);
  return name;
}

void main(){
}