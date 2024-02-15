import 'package:flutter/cupertino.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Notifications Page',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
