import 'package:flutter/material.dart';

import '../routes/_image_routes.dart';

class LocatedAt extends StatelessWidget {
  const LocatedAt({super.key, required this.country});
  final String country;

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
        Text(
          country,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
