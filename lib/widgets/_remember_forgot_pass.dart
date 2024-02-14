import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RememberAndForgotPassword extends StatelessWidget {
  const RememberAndForgotPassword({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    double dHeight = MediaQuery.of(context).size.height;
    return Container(
      // color: Colors.red,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                tristate: true,
                value: false,
                onChanged: (bool? value) {},
                // onChanged: (bool? value) {
                //   setState(() {
                //     isChecked = value;
                //   });
                // },
              ),
              Text('Remember me')
            ],
          ),
          // Forgot_Password()
        ],
      ),
    );
  }
}



class Forgot_Password extends StatefulWidget {
  const Forgot_Password({Key? key}) : super(key: key);

  @override
  State<Forgot_Password> createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Forgot password?',
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            // color: CupertinoColors.activeBlue,
          ),
        ),
        SizedBox(width: 5),
        MouseRegion(
          onHover: (event) {
            setState(() {
              _isHovering = true;
            });
          },
          onExit: (event) {
            setState(() {
              _isHovering = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
            child: Text(
              'Reset',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isHovering ? Colors.blue.shade200 : CupertinoColors.activeBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}
