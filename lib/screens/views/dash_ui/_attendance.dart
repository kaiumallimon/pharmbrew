import 'package:flutter/cupertino.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Attendace Page',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
    );
  }
}
