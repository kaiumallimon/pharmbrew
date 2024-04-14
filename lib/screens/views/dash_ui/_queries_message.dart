import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/_fetch_all_employee.dart';
import '../../../data/_fetch_employee_data.dart';
import '../../../data/_fetch_messages.dart';
import '../../../data/_fetch_senders.dart';
import '../../../data/_send_message_to_employee.dart';

class Queries extends StatefulWidget {
  const Queries({super.key});

  @override
  State<Queries> createState() => _QueriesState();
}

class _QueriesState extends State<Queries> {
  late String userId = '';

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final x = prefs.getString('loggedInUserId');
    userId = x ?? '';

    setState(() {});
  }

  bool isChatOpen = false;
  late Timer timer;
  late Timer timer2;
  // late Timer timer3;
  List<Map<String, dynamic>> senders = [];
  List<dynamic> messages = [];
  List<dynamic> allEmployees = [];

  @override
  void initState() {
    super.initState();
    initData();
    print("Logged in: $userId");
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      setState(() {
        fetchData();
        // print('refreshed');
      });
    });

    timer2 = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        if (inFocusSender.isNotEmpty) {
          fetchMessage();
        }
      });
    });

    setState(() {
      _fetchEmployees();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timer2.cancel();
  }

  void fetchMessage() async {
    List<dynamic> fetchedMessages = await FetchMessages.fetch(inFocusSender);
    messages.clear();
    setState(() {
      messages = fetchedMessages;
    });

    print("messages: $messages");
  }

  void _fetchEmployees() async {
    allEmployees = await FetchAllEmployee.fetch();
  }

  void fetchData() async {
    List<dynamic> fetchedSenders = await FetchSenders.fetchEmployee();
    List senderIDs = [];
    // fetchedSenders.map((sender) => sender['sender_id']).toList();
    // fetchedSenders.map((sender) => sender['sender_id']).toList();

    for (var sender in fetchedSenders) {
      if (userId != sender['sender_id']) {
        senderIDs.add(sender['sender_id']);
      }
    }
    print('Sender IDs: $senderIDs');

    List<Map<String, dynamic>> loadedSenders = [];
    for (var senderID in senderIDs) {
      Map<String, dynamic> employeeData =
          await FetchEmployeeData.fetchEmployee(senderID);
      String id = employeeData['userId'];
      String name = employeeData['name'];
      String profilePic = employeeData['profile_pic'];
      String designation = employeeData['designation'];

      loadedSenders.add({
        'id': id,
        'name': name,
        'profilePic': profilePic,
        'designation': designation,
      });
    }

    setState(() {
      senders = loadedSenders;
    });
    // print('Data fetched');
    // print(senders);
  }

  @override
  Widget build(BuildContext context) {
    return senders.isNotEmpty
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Queries",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Container(
                              //         width: 400,
                              //         decoration: BoxDecoration(
                              //           color: Colors.grey.shade300,
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //         child: const TextField(
                              //           decoration: InputDecoration(
                              //             hintText: 'Search',
                              //             prefixIcon: Icon(Icons.search),
                              //             border: InputBorder.none,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              //
                              // const SizedBox(
                              //   height: 20,
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 450,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              activeList = 0;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                color: activeList == 0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Inbox',
                                                    style: TextStyle(
                                                        color: activeList == 0
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ],
                                              )),
                                        )),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              activeList = 2;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                color: activeList == 2
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Search',
                                                    style: TextStyle(
                                                        color: activeList == 2
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ],
                                              )),
                                        )),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              activeList = 1;
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                color: activeList == 1
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'All Employees',
                                                    style: TextStyle(
                                                        color: activeList == 1
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ],
                                              )),
                                        )),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height - 240,
                                // color: Colors.red,
                                child: activeList == 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: senders.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    isChatOpen = true;
                                                    inFocusSender =
                                                        senders[index]['id'];
                                                    selectedChatData = senders[
                                                        index]; // Store selected chat data
                                                    print(selectedChatData);
                                                    // Clear the text field when switching inboxes
                                                    clearTextField();
                                                  });
                                                },
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  backgroundImage:
                                                                      CachedNetworkImageProvider(
                                                                    getImageLink(
                                                                      senders[index]
                                                                          [
                                                                          'profilePic'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    child: Text(
                                                                      senders[index]
                                                                          [
                                                                          'name'],
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // messages[index]['status_admin']=="unread"?

                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        // color: Colors.red,
                                                        child: Center(
                                                            child: Container(
                                                                height: 8,
                                                                width: 8,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                ))),
                                                      )
                                                      // : SizedBox.shrink()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : activeList == 1
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: allEmployees.length,
                                            itemBuilder: (context, index) {
                                              return Column(children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 5),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                  getImageLink(
                                                                    allEmployees[
                                                                            index]
                                                                        [
                                                                        'profile_pic'],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    allEmployees[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                              ]);
                                            },
                                          )
                                        : Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      width: 400,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Search',
                                                          prefixIcon: Icon(
                                                              Icons.search),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    300,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                              )
                            ],
                          ),
                        ),

                        Container(
                          width: 1,
                          height: MediaQuery.of(context).size.height - 130,
                          color: Colors.grey,
                        ),

                        // const SizedBox(width: 20),

                        !isChatOpen
                            ? Expanded(
                                flex: 2,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.chat),
                                      SizedBox(height: 20),
                                      Text(
                                        "Click on a chat to open inbox",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      getImageLink(
                                                          selectedChatData[
                                                              'profilePic'])),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      selectedChatData['name'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      selectedChatData[
                                                          'designation'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isChatOpen = false;
                                                  inFocusSender = "";
                                                  selectedChatData.clear();
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.grey.shade200,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              250,
                                      child: ListView.builder(
                                        itemCount: messages.length,
                                        itemBuilder: (context, index) {
                                          return messages[index]['send_by'] ==
                                                  'employee'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 450),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .orangeAccent
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        margin: EdgeInsets.only(
                                                            left: 20,
                                                            top: 10,
                                                            bottom: 10),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                            messages[index][
                                                                'message_content'],
                                                            maxLines: null,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16)),
                                                      )
                                                    ])
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 450),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                CupertinoColors
                                                                    .activeBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        margin: EdgeInsets.only(
                                                            right: 20,
                                                            top: 10,
                                                            bottom: 10),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12,
                                                                vertical: 8),
                                                        child: Text(
                                                            messages[index][
                                                                'message_content'],
                                                            maxLines: null,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      )
                                                    ]);
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextField(
                                                controller: messageController,
                                                maxLines: null,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Type a message',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              String text = messageController
                                                  .text
                                                  .toString()
                                                  .trim();

                                              print(userId);

                                              if (text.isNotEmpty) {
                                                SendMessages.toEmployee(userId,
                                                    inFocusSender, text);
                                                messageController.clear();
                                              }
                                            },
                                            icon: Icon(
                                              Icons.send_rounded,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  String getImageLink(String? image) {
    if (image == null || image.isEmpty) {
      return 'https://placehold.co/600x400/png';
    }
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/$image";
    return imageUrl;
  }

  late var inFocusSender = "";

  Map<String, dynamic> getSenderDataLocal(String id) {
    for (var sender in senders) {
      if (sender['id'] == id) {
        return sender;
      }
    }
    return {};
  }

  Map<String, dynamic> selectedChatData = {};
  TextEditingController messageController = TextEditingController();

  void clearTextField() {
    messageController.clear();
  }

  int activeList = 0;
}
