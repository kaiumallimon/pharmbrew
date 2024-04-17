import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
    );
  }
}
