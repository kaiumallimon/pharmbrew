import 'package:flutter/cupertino.dart';

class Queries extends StatefulWidget {
  const Queries({super.key});

  @override
  State<Queries> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Queries> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Mails/Messages Page',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
