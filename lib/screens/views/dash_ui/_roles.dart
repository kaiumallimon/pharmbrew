import 'package:flutter/cupertino.dart';

class RolesAndAccess extends StatefulWidget {
  const RolesAndAccess({super.key});

  @override
  State<RolesAndAccess> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<RolesAndAccess> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Roles and Access Page',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
