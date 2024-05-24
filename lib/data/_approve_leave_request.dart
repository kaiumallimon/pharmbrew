import 'package:http/http.dart' as http;

class ApproveLeaveRequest {
  static Future<bool> approve(String status, String approvedBy,
      String approveTime, String leaveId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://bcrypt.site/scripts/php/approve_leave_request.php'),
          body: {
            "status": status,
            "approved_by": approvedBy,
            "approve_time": approveTime,
            "requestId": leaveId,
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to load requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }
}
