
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberAndForgotPassword extends StatefulWidget {
  const RememberAndForgotPassword({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  _RememberAndForgotPasswordState createState() =>
      _RememberAndForgotPasswordState();
}

class _RememberAndForgotPasswordState
    extends State<RememberAndForgotPassword> {
  bool isChecked = false;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isChecked = preferences.getBool("remembered") ?? false;
    });
  }

  Future<void> _updateSharedPreferences(bool value) async {
    setState(() {
      isChecked = value;
    });
    await preferences.setBool("remembered", isChecked);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(

                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                    _updateSharedPreferences(isChecked);
                  });
                },
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
