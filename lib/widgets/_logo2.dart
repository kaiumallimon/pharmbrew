import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import '../routes/_image_routes.dart';

class Logo2 extends StatelessWidget {
  const Logo2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   ImageRoutes.pills,
          //   scale: 3,
          // ),
          Transform.translate(
            offset: const Offset(0, 3),
            child: Container(
              width: 40,
              child: Lottie.asset(
                ImageRoutes.tabletAnimation,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // const SizedBox(
          //   width: 6,
          // ),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: Container(
              // height: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'pharmabrew',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
