// import 'dart:async';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// Future<void> uploadFile(File file, String id) async {
//   var uri = Uri.parse('https://bcrypt.site/scripts/php/upload_private_file.php'); // Replace with your API URL
//
//   var request = http.MultipartRequest('POST', uri);
//   request.fields['id'] = id;
//   request.files.add(await http.MultipartFile.fromPath('file', file.path));
//
//   var response = await request.send();
//   if (response.statusCode == 200) {
//     print('Uploaded successfully');
//   } else {
//     print('Failed to upload: ${response.reasonPhrase}');
//   }
// }
