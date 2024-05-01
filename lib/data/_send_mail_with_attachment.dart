import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import MediaType from http_parser

Future<bool> sendEmailWithAttachment(
    String to,
    String subject,
    String text,
    Uint8List pdfBytes,
    ) async {
  try {
    // API endpoint URL
    String url = 'http://nodejs-mail-with-attachment.vercel.app/send-email';

    // Create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add fields to the request
    request.fields['subject'] = subject;
    request.fields['text'] = text;
    request.fields['to'] = to;

    // Attach PDF file
    request.files.add(
      http.MultipartFile.fromBytes(
        'pdfData',
        pdfBytes,
        filename: 'invoice.pdf',
        contentType: MediaType('application', 'pdf'), // Use MediaType from http_parser
      ),
    );

    // Send multipart request
    var response = await request.send();

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Email sent successfully!');
      return true;
    } else {
      print('Failed to send email. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error sending email: $e');
    return false;
  }
}
