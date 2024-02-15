import 'package:flutter/cupertino.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Account Registration Page',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
