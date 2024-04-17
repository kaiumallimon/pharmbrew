import 'package:flutter/material.dart';
import 'package:pharmbrew/routes/_image_routes.dart';

class LoginWeb2 extends StatefulWidget {
  const LoginWeb2({Key? key}) : super(key: key);

  @override
  State<LoginWeb2> createState() => _LoginWeb2State();
}

class _LoginWeb2State extends State<LoginWeb2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width, // Match screen width
            height: MediaQuery.of(context).size.height, // Match screen height
            child: Image.asset(
              ImageRoutes.peels3,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height/2,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
