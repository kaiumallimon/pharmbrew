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

class Forgot_Password extends StatelessWidget {
  const Forgot_Password({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Forgot password?',
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              // color: CupertinoColors.activeBlue,
            )),

            SizedBox(width: 5,),

            Text('Reset', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ))
      ],
    );
  }
}
