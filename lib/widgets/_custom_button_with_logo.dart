import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../routes/_image_routes.dart';

class CustomButtonWithImageLogo extends StatelessWidget {
  const CustomButtonWithImageLogo({
    super.key, required this.logo, required this.label, required this.width, required this.height,
  });

  final String logo;
  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10)),
            backgroundColor: Colors.grey.shade300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(logo.trim().isNotEmpty)
              Image.asset(logo,scale: 2,)
            ,
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
