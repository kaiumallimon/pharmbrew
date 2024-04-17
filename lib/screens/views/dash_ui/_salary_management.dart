import 'package:flutter/cupertino.dart';

class SalaryManagement extends StatefulWidget {
  const SalaryManagement({super.key});

  @override
  State<SalaryManagement> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<SalaryManagement> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Salary Management Page',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
    );
  }
}
