import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;

class Dummy {
  static Future<void> insertDummy() async {
    var currentProtocol = window.location.protocol;
    var apiUrl = '$currentProtocol//bcrypt.site/scripts/php/register.php';

    final response = await http.post(Uri.parse(apiUrl), body: {
      {
        "name": "John Doe",
        "email": "johndoe@example.com",
        "dateofbirth": "1990-05-15",
        "designation": "Software Engineer",
        "password": "testpassword",
        "role": "employee",
        "profile_pic": "https://example.com/profile_pic.jpg",
        "rating": 4.5,
        "department_id": 3000
      }
    });

    if (response.statusCode == 200) {
      json.decode(response.body);
      // return responseData;
    } else {
      // return {"success": false, "response": "Failed to insert data"};
    }
  }
}
