import 'package:flutter/material.dart';

import '../routes/_image_routes.dart';

class LocatedAt extends StatelessWidget {
  const LocatedAt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "I'm Located in",
          style: TextStyle(color: Colors.grey.shade500),
        ),
        space5w(),
        Image.asset(
          ImageRoutes.bd_flag,
          scale: 2,
        ),
        space5w(),
        const Text(
          "Bangladesh",
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Container or_margin() {
    return Container(
      width: 150,
      height: 1,
      color: Colors.grey.shade300,
    );
  }

  SizedBox space5w() {
    return const SizedBox(
      width: 5,
    );
  }
}
