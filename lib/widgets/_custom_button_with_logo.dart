import 'dart:math';

import 'package:flutter/material.dart';

import '../routes/_image_routes.dart';

class CustomButtonWithImageLogo extends StatelessWidget {
  const CustomButtonWithImageLogo({
    super.key, required this.logo, required this.label,
  });

  final String logo;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 350,
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
