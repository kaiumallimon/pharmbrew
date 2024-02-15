import 'package:flutter/cupertino.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Analytics Page',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
