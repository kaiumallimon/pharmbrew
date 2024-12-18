import 'package:flutter/material.dart';

class CustomButtonWithImageLogo extends StatelessWidget {
  const CustomButtonWithImageLogo({
    super.key,
    required this.logo,
    required this.label,
    required this.width,
    required this.height,
    required this.onClick,
  });

  final String logo;
  final String label;
  final double width;
  final double height;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: () {
          onClick();
        },
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Theme.of(context).colorScheme.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo.trim().isNotEmpty)
              Image.asset(
                logo,
                scale: 2,
              ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
