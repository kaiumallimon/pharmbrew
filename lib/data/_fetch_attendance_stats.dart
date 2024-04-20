import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchAttendanceStatsIndividual{
  static Future<List<dynamic>> fetch()async{
    try {
      final response = await http.get(
          Uri.parse('https://bcrypt.site/scripts/php/attendance_individual.php'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }
}


Future<List> fetchAttendanceAbsents(String userId) async{
  List<dynamic> attendances=await FetchAttendanceStatsIndividual.fetch();
  List<dynamic> absents=[];
  for(var attendance in attendances){
    if(attendance['userId']==userId){
     String absentDates=attendance['absent_dates'];
      List absentsLocal=absentDates.split(', ');
      absents.addAll(absentsLocal);
    }
  }

  return absents;
}

main() async{
  List absents=await fetchAttendanceAbsents('EMP20240415083627');
  print(absents);
}