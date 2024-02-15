import 'package:flutter/cupertino.dart';

class EmployeesAll extends StatefulWidget {
  const EmployeesAll({super.key});

  @override
  State<EmployeesAll> createState() => _EmployeesAllState();
}

class _EmployeesAllState extends State<EmployeesAll> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Employees',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
