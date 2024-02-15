import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.width,
    required this.height,
    required this.controller,
  });

  final String label;
  final IconData icon;
  final double width;
  final double height;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          // contentPadding: EdgeInsets.all(20),
          prefixIcon: Container(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Icon(icon)),
          filled: true,
          fillColor: Colors.grey.shade50,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: CupertinoColors.activeOrange, width: 2)),
        ),
      ),
    );
  }
}
