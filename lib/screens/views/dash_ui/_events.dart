import 'package:flutter/cupertino.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Events Page',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
    );
  }
}
