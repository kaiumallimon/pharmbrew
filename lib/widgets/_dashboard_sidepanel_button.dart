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

      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
        margin: const EdgeInsets.only(left: 15, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: controller
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),

          //shadow:

          // boxShadow: controller?[
          //   BoxShadow(
          //     color: Color(0xFF0f1024),
          //     spreadRadius: 1,
          //     blurRadius: 15,
          //     offset: const Offset(4,4)
          //   ),
          //   BoxShadow(
          //       color: Theme.of(context).colorScheme.surface,
          //       spreadRadius: 1,
          //       blurRadius: 15,
          //       offset: const Offset(-4,-4)
          //   )
          // ]:null,
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
