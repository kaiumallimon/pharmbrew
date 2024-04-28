import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class EmployeeLeaveRequest extends StatefulWidget {
  const EmployeeLeaveRequest({super.key});

  @override
  State<EmployeeLeaveRequest> createState() => _EmployeeLeaveRequestState();
}

class _EmployeeLeaveRequestState extends State<EmployeeLeaveRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Employee Leave Request',style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),),
      ),
    );
  }
}
