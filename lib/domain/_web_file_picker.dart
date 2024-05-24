import 'dart:html' as html;

class WebFilePicker {
  void pickFile({required Function(html.File file) onFilePicked}) {
    final input = html.FileUploadInputElement();
    input.accept = '*/*'; // Allow any file type
    input.multiple = false; // Only allow single file selection
    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        onFilePicked(files.first); // Pass the first file to the callback
      }
    });
    input.click();
  }
}
