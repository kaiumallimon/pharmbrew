import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/_fetch_employee_data.dart';
import '../../../data/fetch_notification.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  List<dynamic> notifications = [];
  List<Map<String, dynamic>> employeeDatas = [];
  late String userId = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    initData();
    _fetchNotification();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => _fetchNotification());
  }

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final x = prefs.getString('loggedInUserId');
    setState(() {
      userId = x ?? '';
    });
  }

  Future<void> _fetchNotification() async {
    final fetchedNotifications = await FetchNotification.fetch();
    setState(() {
      notifications = fetchedNotifications;
    });
    initEmpData();
  }

  void initEmpData() async {
    for (var notification in notifications) {
      final senderId = notification['sender_id'];
      final employeeData = await FetchEmployeeData.fetchEmployee(senderId);
      print("Data: $employeeData" );
      setState(() {
        employeeDatas.add(employeeData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return notifications.length > 0 ? Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 140,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 60,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.black,
                                      backgroundImage: NetworkImage(
                                          getEmployeeImage(
                                              notifications[index]['sender_id'])),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notifications[index]['content'],
                                          style: const TextStyle(
                                              fontSize: 17)
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      getTime(notifications[index]['created_at']),
                                    ),
                                    // width: 200,
                                    // color: Colors.green,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        )
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    ) : const Center(child: CircularProgressIndicator());
  }

  String getEmployeeImage(String userId) {
    print(employeeDatas);
    for (var employeeData in employeeDatas) {
      if (employeeData['userId'] == userId) {
        return "https://bcrypt.site/uploads/images/profile/picture/${employeeData['profile_pic']}";
      }
    }
    return '';
  }
// 2024-04-15 10:07:35
  String getTime(String raw){
    var parts = raw.split(' ');
    String date = parts[0];
    String time = parts[1];

    DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    DateTime newTime = parsedTime.add(Duration(hours: 6));
    String formattedTime = DateFormat('hh:mm a').format(newTime);

    return '$formattedTime, $date';
  }
}
