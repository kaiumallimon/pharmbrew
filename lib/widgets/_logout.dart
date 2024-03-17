import 'package:flutter/material.dart';
import 'package:pharmbrew/utils/_logout_util.dart';

class LogoutDashboard extends StatefulWidget {
  const LogoutDashboard({super.key});

  @override
  State<LogoutDashboard> createState() => _LogoutDashboardState();
}

class _LogoutDashboardState extends State<LogoutDashboard> {
  bool isHoverd = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHoverd = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHoverd = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          logout(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
          color: isHoverd
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          height: 50,
          // margin: EdgeInsets.only(left: 10,right: 10),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.logout,
                    color: isHoverd ? Colors.white : Colors.black,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: isHoverd ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
