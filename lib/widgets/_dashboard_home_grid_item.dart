import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardGridItem extends StatefulWidget {
  const DashboardGridItem(
      {super.key,
      required this.title,
      required this.data,
      required this.image, required this.background, required this.textColor, this.isCost=false});

  final String title;
  final String data;
  final String image;
  final Color background;
  final Color textColor;
  final bool isCost;

  @override
  State<DashboardGridItem> createState() => _DashboardGridItemState();
}

class _DashboardGridItemState extends State<DashboardGridItem> {
  late Color color;
  late Color oppositeColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = getRandomColor();
    oppositeColor = getOppositeColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(340, 180),
              child: Container(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      color: widget.textColor,
                      height: 60,
                      width: 60,
                      widget.image,

                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.data,
                              style: GoogleFonts.inter(
                                fontSize: widget.isCost? 25:35,
                                fontWeight: FontWeight.bold,
                                color: widget.textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Color getRandomColor() {
    Random random = Random();
    // Generate random RGB values
    int red = random.nextInt(256); // 0 to 255
    int green = random.nextInt(256); // 0 to 255
    int blue = random.nextInt(256); // 0 to 255
    // Create and return the Color object
    return Color.fromARGB(255, red, green, blue);
  }

  Color getOppositeColor(Color color) {
    // Calculate the opposite color (complementary color)
    int oppositeRed = 255 - color.red;
    int oppositeGreen = 255 - color.green;
    int oppositeBlue = 255 - color.blue;
    // Create and return the opposite Color object
    return Color.fromARGB(255, oppositeRed, oppositeGreen, oppositeBlue);
  }
}
