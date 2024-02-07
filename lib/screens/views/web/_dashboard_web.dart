import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_logo.dart';

import '../../../widgets/_logo2.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  Future<void> _handleRefresh() async {
    // Perform your asynchronous operation here
    // For example, fetch new data from a network source
    await Future.delayed(Duration(seconds: 2)); // Simulating a delay

    // After the asynchronous operation is complete, call setState to rebuild the UI
    setState(() {
      // Update the UI or refresh data
    });
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Row(
              children: [
                //logo part
                Container(
                  width: 200,
                  color: Theme.of(context).colorScheme.background,
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      // color: Colors.red,
                      child: const Logo2(),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) {
                              setState(() {
                                // Change the state to indicate hover
                                isHovered = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                // Change the state to indicate not hover
                                isHovered = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.home,
                                  color: isHovered
                                      ? Colors.blue
                                      : Colors.white, // Change color on hover
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                    color: isHovered
                                        ? Colors.blue
                                        : Colors.white, // Change text color on hover
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),

                //menu buttons

                Expanded(
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(),
                    ),
                  ),
                )
              ],
            )));
  }
}
