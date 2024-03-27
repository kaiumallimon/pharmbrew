import 'package:flutter/material.dart';

class AddProductFields extends StatelessWidget {
  const AddProductFields({super.key, required this.controller, required this.labelText});
  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green.shade500,
                width: 2
            ),
          ),
        ),
      ),
    );
  }
}
