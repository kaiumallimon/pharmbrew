import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SidePanelButton extends StatelessWidget {
  const SidePanelButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.controller,
      required this.onClick});

  final String label;
  final IconData icon;
  final bool controller;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: controller
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: controller ? Colors.black : Colors.white,
                size: 18,
              ),
              SizedBox(width: 20), // Adjust the width according to your preference
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: controller ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
