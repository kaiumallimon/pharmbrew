import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchLeaveRequestData {
  static Future<List<dynamic>> fetch(String userId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://bcrypt.site/scripts/php/get_leave_request_data.php'),
          body: {"userId": userId});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  static Future<List<dynamic>> fetchAll() async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://bcrypt.site/scripts/php/get_all_leave_requests.php'),
         );

      if (response.statusCode == 200) {
        List<dynamic>result= json.decode(response.body);

        List<dynamic>data=[];
        for(var i=0;i<result.length;i++){
          if(result[i]['STATUS']=='Pending'){
            data.add(result[i]);
          }
        }
        return data;
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }


  static Future<List<dynamic>> fetchApproved() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://bcrypt.site/scripts/php/get_all_leave_requests.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic>result= json.decode(response.body);

        List<dynamic>data=[];
        for(var local in result){
          if(local['STATUS']=='Approved' || local['STATUS']=='Rejected'){
            data.add(local);
          }
        }
        return data;
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }
}

void main()async{
  var data= await FetchLeaveRequestData.fetchAll();
  print(data);
}
