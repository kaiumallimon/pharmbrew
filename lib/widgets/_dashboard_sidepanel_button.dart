import 'package:flutter/material.dart';

class SidePanelButton extends StatelessWidget {
  const SidePanelButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.controller,
      required this.onClick,
      this.notificationDot = false});

  final String label;
  final IconData icon;
  final bool controller;
  final VoidCallback onClick;
  final bool notificationDot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(left: 15, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: controller
              ? Colors.white
              : Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: controller ? Colors.black : Colors.white,
                size: 18,
              ),
              const SizedBox(
                  width: 20), // Adjust the width according to your preference
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: controller ? Colors.black : Colors.white,
                ),
              ),

              if (notificationDot)
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    // height: 20,
                    // width: 20,
                      padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    // child: Center(
                    //   child: Text(
                    //     '100',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 13,
                    //     ),
                    //   ),
                    // )
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
