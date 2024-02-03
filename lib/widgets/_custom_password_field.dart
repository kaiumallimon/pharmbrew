import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final String label;
  final IconData icon;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 60,
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Container(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Icon(widget.icon),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: CupertinoColors.activeOrange,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
