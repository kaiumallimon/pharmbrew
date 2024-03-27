import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../routes/_image_routes.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image.asset(
        //   ImageRoutes.pills,
        //   scale: 2,
        // ),
        // const SizedBox(
        //   width: 6,
        // ),

        SizedBox(width: 60, child: Lottie.asset(ImageRoutes.tabletAnimation)),
        Container(
          // height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('pharmabrew',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ],
          ),
        )
      ],
    );
  }
}
