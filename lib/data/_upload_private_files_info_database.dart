import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertPrivateFilesDatabase{
  static Future<void>  insert(String id,String fileName, String date, String fileSize) async {
    try {
      final response = await http.post(
          Uri.parse('https://bcrypt.site/scripts/php/upload_private_file_database.php'),
          body: {
            'fileName': fileName,
            'uploadDate': date,
            'fileType': fileName.split('.').last,
            'fileSize': fileSize,
            'user': id,
          });

      if (response.statusCode == 200) {

      } else {
        throw Exception('Failed to insert : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to insert: $e');
    }
  }
}