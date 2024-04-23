import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_error_dialog.dart';

import '../widgets/_detailed_announcement.dart';

void showCustomErrorDialog(String errorText, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(errorMessage: errorText);
      });
}

// void showDetailedAnnouncement(BuildContext context, String title,
//     String description, String publishDate, String start, String end) {
//
//   print(
//     'Title: $title\n'
//     'Description: $description\n'
//     'Publish Date: $publishDate\n'
//     'Start: $start\n'
//     'End: $end\n'
//   );
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return DetailedAnnouncement(
//             title: title,
//             description: description,
//             publishDate: publishDate,
//             start: start,
//             end: end
//         );
//       });
// }
