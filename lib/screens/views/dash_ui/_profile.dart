import 'package:flutter/cupertino.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Edit Profile Page',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
    );
  }
}
