import 'package:carousel_slider/carousel_slider.dart';
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
      duration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 60, right: 40, bottom: 20, top: 10),
      height: widget.dHeight - 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Rounded corners for the container
        border: Border.all(
          color: isBorderVisible ? Colors.blue : Colors.transparent,
          width: 4.0,
        ),
      ),
      child: ClipRRect( // Clip rounded corners around the carousel
        borderRadius: BorderRadius.circular(30),
        child: CarouselSlider(
          items: [
            'assets/images/carousal1.jpg',
            'assets/images/carousal2.jpg',
            'assets/images/carousal3.jpg',
            'assets/images/carousal4.jpg',
            'assets/images/carousal5.jpg',
            'assets/images/carousal6.jpg',
          ].map((assetPath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Rounded corners for each image
                    color: Colors.grey,
                  ),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(milliseconds: 2000),
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            onPageChanged: (index, _) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  int currentIndex = 0;
  List<String> images = [
    'assets/images/carousal1.jpg',
    'assets/images/carousal2.jpg',
    'assets/images/carousal3.jpg',
    'assets/images/carousal4.jpg',
    'assets/images/carousal5.jpg',
    'assets/images/carousal6.jpg',
  ];
}
