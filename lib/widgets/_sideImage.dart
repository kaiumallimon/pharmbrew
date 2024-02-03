import 'package:flutter/material.dart';
import '../routes/_image_routes.dart';

class SideImageCol extends StatefulWidget {
  const SideImageCol({
    Key? key,
    required this.dHeight,
  }) : super(key: key);

  final double dHeight;

  @override
  _SideImageColState createState() => _SideImageColState();
}

class _SideImageColState extends State<SideImageCol> {
  bool isBorderVisible = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 60, right: 40, bottom: 20, top: 10),
      // color: Colors.red,
      height: widget.dHeight - 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBorderVisible ? Colors.blue : Colors.transparent,
          width: 4.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          ImageRoutes.pharma,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
