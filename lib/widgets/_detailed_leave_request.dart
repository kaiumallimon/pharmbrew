import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailedLeaveRequest extends StatefulWidget {
  const DetailedLeaveRequest({super.key});

  @override
  State<DetailedLeaveRequest> createState() => _DetailedLeaveRequestState();
}

class _DetailedLeaveRequestState extends State<DetailedLeaveRequest> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void showDetailedAnnouncement(
    BuildContext context,
    String title,
    String description,
    String publishDate,
    String start,
    String end,
    String publisher,
    dynamic announcementMap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DetailedLeaveRequest();
    },
  );
}
