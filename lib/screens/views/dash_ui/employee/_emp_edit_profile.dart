import 'package:flutter/cupertino.dart';

class EmployeeEditProfile extends StatefulWidget {
  const EmployeeEditProfile({super.key});

  @override
  State<EmployeeEditProfile> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<EmployeeEditProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Employee Edit Profile Page',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
