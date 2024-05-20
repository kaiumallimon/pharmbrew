import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchPrivateFilesDatabase{
  static Future<List<dynamic>> fetch(String user)async{
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/get_private_file_info.php'),
          body: {
            'user': user,
          });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load: $e');
    }
  }
}

void main() async{
  List data=await FetchPrivateFilesDatabase.fetch('EMP20240421155706');
  print(data);
}
