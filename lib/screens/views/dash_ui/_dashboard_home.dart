import 'package:flutter/cupertino.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<DashboardHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Dashboard Home Page',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
