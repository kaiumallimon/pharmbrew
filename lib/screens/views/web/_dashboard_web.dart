import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_dashboard_mainPanel.dart';
import 'package:pharmbrew/widgets/_logout.dart';
import '../../../widgets/_dashboard_sidepanel_button.dart';
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
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay

    // After the asynchronous operation is complete, call setState to rebuild the UI
    setState(() {
      // Update the UI or refresh data
    });
  }

  void switchPage(int index) {
    setState(() {
      inFocus = index;
    });
  }

  bool isHovered = false;
  int inFocus = 0;

  ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Row(
          children: [
            //sidebar
            Container(
              width: 200,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  //logo part
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Logo2(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController, // Add ScrollController here
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SidePanelButton(
                            label: 'Home',
                            icon: Icons.home,
                            controller: inFocus == 0,
                            onClick: (){
                              setState(() {
                                inFocus=0;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Add employee',
                            icon: CupertinoIcons.add,
                            controller: inFocus == 1,
                            onClick: () {
                              setState(() {
                                inFocus = 1;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Employees',
                            icon: CupertinoIcons.group_solid,
                            controller: inFocus == 2,
                            onClick: () {
                              setState(() {
                                inFocus = 2;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Edit Profile',
                            icon: Icons.edit,
                            controller: inFocus == 3,
                            onClick: () {
                              setState(() {
                                inFocus = 3;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Notifications',
                            icon: Icons.notifications,
                            controller: inFocus == 4,
                            onClick: () {
                              setState(() {
                                inFocus = 4;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Access',
                            icon: Icons.security,
                            controller: inFocus == 5,
                            onClick: () {
                              setState(() {
                                inFocus = 5;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Finance',
                            icon: CupertinoIcons.money_dollar_circle_fill,
                            controller: inFocus == 6,
                            onClick: () {
                              setState(() {
                                inFocus = 6;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Attendance',
                            icon: Icons.person,
                            controller: inFocus == 7,
                            onClick: () {
                              setState(() {
                                inFocus = 7;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Events',
                            icon: Icons.event,
                            controller: inFocus == 8,
                            onClick: () {
                              setState(() {
                                inFocus = 8;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Analytics',
                            icon: Icons.analytics,
                            controller: inFocus == 9,
                            onClick: () {
                              setState(() {
                                inFocus = 9;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Queries',
                            icon: Icons.inbox,
                            controller: inFocus == 10,
                            onClick: () {
                              setState(() {
                                inFocus = 10;
                              });
                            },
                          ),
                          SidePanelButton(
                            label: 'Settings',
                            icon: Icons.settings,
                            controller: inFocus == 11,
                            onClick: () {
                              setState(() {
                                inFocus = 11;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  //logout dashboard
                  const LogoutDashboard(),
                ],
              ),
            ),

            //main screen
            DashboardMainPanel(inFocus: inFocus),
          ],
        ),
      ),
    );
  }
}
