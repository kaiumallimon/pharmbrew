import 'package:http/http.dart' as http;

Future<void> sendEmail(String to, String subject, String text) async {
  const String apiUrl = 'https://nodejs-mail-server.vercel.app/send-email';

  final response = await http.post(Uri.parse(apiUrl), body: {
    'subject': subject,
    'text': text,
    'to': to,
  });

  if (response.statusCode == 200) {
    // Email sent successfully
  } else {
    // Failed to send email
  }
}
