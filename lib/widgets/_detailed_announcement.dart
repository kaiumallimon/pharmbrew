import 'dart:typed_data';
import 'dart:html' as html; // Import 'html' for web-specific operations
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

class DetailedAnnouncement extends StatefulWidget {
  const DetailedAnnouncement({
    Key? key,
    required this.title,
    required this.description,
    required this.publishDate,
    required this.start,
    required this.end,
    required this.publisher,
    required this.announcementMap, // Add callback function for generating PDF
  }) : super(key: key);

  final String title;
  final String description;
  final String publishDate;
  final String start;
  final String end;
  final String publisher;
  final dynamic announcementMap; // Callback function for generating PDF

  @override
  State<DetailedAnnouncement> createState() => _DetailedAnnouncementState();
}

class _DetailedAnnouncementState extends State<DetailedAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: MediaQuery
            .of(context)
            .size
            .height - 100,
        width: MediaQuery
            .of(context)
            .size
            .width - 100,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  height: 2,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 180,
                  color: Colors.grey,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Event:',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.start != widget.end
                                ? '${widget.start} to ${widget.end}'
                                : '${widget.start}',
                          ),
                        ],
                      ),
                      // Removed the print icon and added a button for generating PDF
                      IconButton(onPressed: (){
                        try{
                          generateAndSavePDF(widget.announcementMap, context);
                        }catch(e){
                          print("error pdf: $e");
                        }
                      }, icon: const Icon(Icons.print))
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  widget.description,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Published on:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      ' ${widget.publishDate}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> generateAndSavePDF(dynamic announcementData, BuildContext context) async {
    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Add content to the PDF document
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  pw.Container(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Flexible(
                          child: pw.Text(
                            announcementData['title'] ?? '', // Added null check
                            maxLines: 3,
                            textAlign: pw.TextAlign.justify,
                            style: pw.TextStyle(
                              fontSize: 23,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.symmetric(vertical: 20),
                  ),
                  pw.Container(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Event:',
                              style: const pw.TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Text(
                              announcementData['start_date'] != announcementData['end_date']
                                  ? '${announcementData['start_date']} to ${announcementData['end_date']}'
                                  : '${announcementData['start_date']}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Container(
                    child: pw.Text(
                      announcementData['description'] ?? '', // Added null check
                      textAlign: pw.TextAlign.justify,
                      maxLines: 30
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Container(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Published on:',
                        ),
                        pw.SizedBox(width: 3),
                        pw.Text(
                          ' ${announcementData['create_time']?.toString().split(' ')[0] ?? ''}', // Added null check
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      );

      // Save the PDF document to bytes
      final pdfBytes = await pdf.save();

      // Create a Blob object from the PDF file bytes
      final blob = html.Blob([Uint8List.fromList(pdfBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create a download link
      final anchor = html.AnchorElement(href: url);
      anchor.download = 'announcement.pdf';
      anchor.text = 'Click here to download the pdf file';

      // Add the download link to the body and trigger the download
      html.document.body!.append(anchor);
      anchor.click();

      // Clean up: remove the download link from the body
      anchor.remove();

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('PDF Generated'),
          content: const Text(
            'The announcement PDF has been generated and downloaded successfully.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Error'),
          content: Text('An error occurred while generating the PDF.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

}
void showDetailedAnnouncement(BuildContext context, String title,
    String description, String publishDate, String start, String end,
    String publisher, dynamic announcementMap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DetailedAnnouncement(
        title: title,
        description: description,
        publishDate: publishDate,
        start: start,
        end: end,
        publisher: publisher,
        announcementMap: announcementMap,
      );
    },
  );
}