import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLiveGradient extends StatefulWidget {
  const CustomLiveGradient({super.key});

  @override
  State<CustomLiveGradient> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CustomLiveGradient> {
  List<Color> colors = [
    // Colors.blue,
    // Colors.green,
    // Colors.orange,
    // Colors.purple,
    // Colors.red,
    // Colors.teal,
    // CupertinoColors.activeBlue
    const Color(0xFFed1c24),
    const Color(0xFF00aeef),
    const Color(0xFFf7a5cb),
    const Color(0x0fffbd49),


    

  ];

  int currentColorIndex = 0;

  @override
  void initState() {
    super.initState();

    // Start a timer to update the gradient color every 2 seconds
    Timer.periodic(const Duration(microseconds: 300), (timer) {
      setState(() {
        currentColorIndex = (currentColorIndex + 1) % colors.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[currentColorIndex],
            colors[(currentColorIndex + 1) % colors.length],
          ],
        ),
      ),
    );
  }
}
