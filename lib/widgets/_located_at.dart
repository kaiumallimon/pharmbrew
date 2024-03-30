import 'package:flutter/material.dart';


class LocatedAt extends StatelessWidget {
  const LocatedAt({super.key, required this.country});
  final String country;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Colors.grey.shade500, size: 20),
        // space5w(),
        space5w(),
        // Text(
        //   "I'm Located in",
        //   style: TextStyle(color: Colors.grey.shade500),
        // ),
        // space5w(),
        // Image.asset(
        //   ImageRoutes.bd_flag,
        //   scale: 2,
        // ),
        space5w(),
        Text(
          country=="BD"?"Bangladesh":country,
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
