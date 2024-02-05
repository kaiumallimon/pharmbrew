import 'package:flutter/material.dart';

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
        Image.asset(
          ImageRoutes.pills,
          scale: 2,
        ),
        const SizedBox(
          width: 6,
        ),
        Container(
          
          // height: 60,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'pharmabrew',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ],
          ),
        )
      ],
    );
  }
}
