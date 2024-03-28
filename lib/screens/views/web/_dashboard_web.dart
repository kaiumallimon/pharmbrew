import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_dashboard_mainPanel.dart';
import 'package:pharmbrew/widgets/_logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/_dashboard_sidepanel_button.dart';
import '../../../widgets/_logo2.dart';

class WebDashboard extends StatefulWidget {
  WebDashboard({Key? key, required this.isAdministrator}) : super(key: key);
  bool isAdministrator;
  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  late String pp = ''; // Initialize pp with an empty string
  late String name = '';
  late String userRole;

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final x = prefs.getString('loggedInUserProfilePic');
    pp = x ?? ''; // Assign x to pp, if x is null assign an empty string

    final nameLocal = prefs.getString('loggedInUserName');
    name = nameLocal ??
        ''; // Assign nameLocal to name, if nameLocal is null assign an empty string

    setState(
        () {}); // Update the state after retrieving data from SharedPreferences
  }

  @override
  void initState() {
    super.initState();
    initData();
    inFocus = widget.isAdministrator ? 0 : 12;
  }

  void switchPage(int index) {
    setState(() {
      inFocus = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    clearSharedPreferences();
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("loggedInUser");
    preferences.remove("loggedInRole");
    preferences.remove("loggedInUserName");
    preferences.remove("loggedInUserProfilePic");
  }

  bool isHovered = false;
  int inFocus = 0;

  final ScrollController _scrollController = ScrollController();

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
                    height: 15,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller:
                          _scrollController, // Add ScrollController here
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),

                          //administrator dashboard
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Home',
                                  icon: Icons.home,
                                  controller: inFocus == 0,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 0;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Add employee',
                                  icon: CupertinoIcons.add,
                                  controller: inFocus == 1,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 1;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Employees',
                                  icon: CupertinoIcons.group_solid,
                                  controller: inFocus == 2,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 2;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                            label: 'Products',
                            icon: Icons.shopping_bag_outlined,
                            controller: inFocus == 15,
                            onClick: () {
                              setState(() {
                                inFocus = 15;
                              });
                            },
                          )
                              : const SizedBox.shrink(),
                          // widget.isAdministrator
                          //     ? SidePanelButton(
                          //         label: 'Edit Profile',
                          //         icon: Icons.edit,
                          //         controller: inFocus == 3,
                          //         onClick: () {
                          //           setState(() {
                          //             inFocus = 3;
                          //           });
                          //         },
                          //       )
                          //     : const SizedBox.shrink(),

                          widget.isAdministrator
                              ? SidePanelButton(
                            label: 'Access',
                            icon: Icons.security,
                            controller: inFocus == 5,
                            onClick: () {
                              setState(() {
                                inFocus = 5;
                              });
                            },
                          )
                              : const SizedBox.shrink(),



                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Notifications',
                                  icon: Icons.notifications,
                                  controller: inFocus == 4,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 4;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),

                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Finance',
                                  icon: CupertinoIcons.money_dollar_circle_fill,
                                  controller: inFocus == 6,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 6;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Attendance',
                                  icon: Icons.person,
                                  controller: inFocus == 7,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 7;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Events',
                                  icon: Icons.event,
                                  controller: inFocus == 8,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 8;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Analytics',
                                  icon: Icons.analytics,
                                  controller: inFocus == 9,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 9;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Queries',
                                  icon: Icons.inbox,
                                  controller: inFocus == 10,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 10;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                          widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Settings',
                                  icon: Icons.settings,
                                  controller: inFocus == 11,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 11;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),

                          //employee dashboard

                          //employee home
                          !widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Home',
                                  icon: Icons.home,
                                  controller: inFocus == 12,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 12;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),

                          //employee edit profile request

                          !widget.isAdministrator
                              ? SidePanelButton(
                                  label: 'Edit Profile',
                                  icon: Icons.edit,
                                  controller: inFocus == 13,
                                  onClick: () {
                                    setState(() {
                                      inFocus = 13;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),



                          !widget.isAdministrator
                              ? SidePanelButton(
                            label: 'Orders',
                            icon: Icons.shopping_cart_outlined,
                            controller: inFocus == 16,
                            onClick: () {
                              setState(() {
                                inFocus = 16;
                              });
                            },
                          )
                              : const SizedBox.shrink(),
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

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
    setState(() {
    });
  }
}
