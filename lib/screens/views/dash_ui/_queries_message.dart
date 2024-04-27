import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/_delete_message.dart';
import '../../../data/_fetch_admins.dart';
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
  dynamic messages = [];
  List<dynamic> allEmployees = [];
  List<dynamic> searchList = [];

  @override
  void initState() {
    super.initState();
    initData();
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        fetchData();
      });
    });

    timer2 = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        if (inFocusSender.isNotEmpty) {
          fetchMessage();
        }
      });
    });

    setState(() {
      _fetchEmployees();
    });

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timer2.cancel();
  }

  void searchEmployee(String query) {
    setState(() {
      if (query.isEmpty) {
        searchList = [];
      } else {
        searchList = allEmployees.where((employee) {
          String name = employee['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void fetchMessage() async {
    if (inFocusSender.isNotEmpty) {

      var response = await FetchMessages.fetch(inFocusSender);
      messages.clear();
      if (response is! Map<String, dynamic>) {
        setState(() {
          messages = response;
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }else{
        setState(() {
          noMessages=true;
        });
      }
    }
  }

  bool noMessages=false;

  void _fetchEmployees() async {
    allEmployees = await FetchAllEmployee.fetch();
  }

  void fetchData() async {
    List<dynamic> fetchedSenders = await FetchSenders.fetchEmployee();
    Set senderIDs = {};

    Map<String, dynamic> admins = await FetchAdmins.fetch();
    List<dynamic> adminIds = admins['userIds'];

    for (var sender in fetchedSenders) {
      if (!adminIds.contains(sender['sender_id'])) {
        senderIDs.add(sender['sender_id']);
      }
      if (!adminIds.contains(sender['receiver_id'])) {
        senderIDs.add(sender['receiver_id']);
      }
    }

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
  }

  @override
  Widget build(BuildContext context) {
    return senders.isNotEmpty && allEmployees.isNotEmpty && userId.isNotEmpty
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                              SizedBox(
                                // color: Colors.yellow,
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
                                                    messages.clear();
                                                    selectedEmployee =
                                                        senders[index]['id'];
                                                    isChatOpen = true;
                                                    // messages.clear();
                                                    inFocusSender =
                                                        senders[index]['id'];
                                                    selectedChatData = senders[
                                                        index]; // Store selected chat data
                                                    // Clear the text field when switching inboxes
                                                    clearTextField();
                                                  });
                                                },
                                                child: Container(
                                                  color: selectedEmployee ==
                                                          senders[index]['id']
                                                      ? Colors.orange.shade100
                                                      : Colors.white,
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
                                              const Divider(
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
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedEmployee =
                                                          allEmployees[index]
                                                              ['userId'];
                                                      // activeList = 0;
                                                      isChatOpen = true;
                                                      messages.clear();
                                                      inFocusSender =
                                                          allEmployees[index]
                                                              ['userId'];
                                                      selectedChatData = {
                                                        'name':
                                                            allEmployees[index]
                                                                ['name'],
                                                        'profilePic':
                                                            allEmployees[index]
                                                                ['profile_pic'],
                                                        'designation':
                                                            allEmployees[index]
                                                                ['designation'],
                                                      };
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
                                                                      child:
                                                                          Text(
                                                                        allEmployees[index]
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
                                                  ),
                                                ),
                                                const Divider(
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      width: 400,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          searchEmployee(value);
                                                        },
                                                        decoration:
                                                            const InputDecoration(
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
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    308,
                                                // color: Colors.red,

                                                //search-list:
                                                child: searchList.isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount:
                                                            searchList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      messages
                                                                          .clear();
                                                                      selectedEmployee =
                                                                          senders[index]['id'];
                                                                      isChatOpen =
                                                                          true;
                                                                      inFocusSender =
                                                                          searchList[index]['userId'];
                                                                      selectedChatData =
                                                                          {
                                                                        'name': searchList[index]['name'],
                                                                        'profilePic': searchList[index]['profile_pic'],
                                                                        'designation': searchList[index]['designation'],
                                                                      };
                                                                      // Clear the text field when switching inboxes
                                                                      clearTextField();
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .white,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            5),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                    child: Row(
                                                                        children: [
                                                                          CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundColor: Colors.green,
                                                                              backgroundImage: CachedNetworkImageProvider(
                                                                                getImageLink(
                                                                                  searchList[index]['profile_pic'],
                                                                                ),
                                                                              )),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                searchList[index]['name'],
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                  thickness: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ]);
                                                        })
                                                    : const Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(Icons
                                                                    .warning),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  "No employees found",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                              )
                            ],
                          ),
                        ),

                        // const SizedBox(width: 20),

                        !isChatOpen
                            ? Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 120,
                                  child: const Column(
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
                                            offset: const Offset(0, 3),
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
                                                margin: const EdgeInsets.only(
                                                    left: 10),
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      selectedChatData['name'],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                      selectedChatData[
                                                          'designation'],
                                                      style: const TextStyle(
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
                                                  // messages.clear();
                                                  inFocusSender = "";
                                                  selectedChatData.clear();
                                                  selectedEmployee = "";
                                                });
                                              },
                                              icon: const Icon(
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
                                      child: messages.isNotEmpty
                                          ? ListView.builder(
                                        controller: _scrollController,
                                              itemCount: messages.length,
                                              itemBuilder: (context, index) {
                                                return messages[index]
                                                            ['send_by'] ==
                                                        'employee'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                            GestureDetector(
                                                              onHorizontalDragEnd: (details) {
                                                                // Calculate the difference in position to determine if it's a right swipe
                                                                if (details.primaryVelocity?.compareTo(0) == 1) {
                                                                  // Positive value indicates a right swipe
                                                                  DeleteMessage.delete(messages[index]['message_id']);
                                                                  // Perform any action here, like navigating to a new screen
                                                                }
                                                              },
                                                              child: AnimatedContainer(
                                                                duration: const Duration(milliseconds: 300),
                                                                curve: Curves.easeInOut,
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        maxWidth:
                                                                            450),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .orangeAccent
                                                                        .shade100,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10)),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 20,
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            5),
                                                                child: Text(
                                                                    messages[
                                                                            index]
                                                                        [
                                                                        'message_content'],
                                                                    maxLines:
                                                                        null,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            )
                                                          ])
                                                    : Column(
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                                GestureDetector(
                                                                  onHorizontalDragEnd: (details) {
                                                                    // Calculate the difference in position to determine if it's a left swipe
                                                                    if (details.primaryVelocity?.compareTo(0) == -1) {
                                                                      // Negative value indicates a left swipe
                                                                      DeleteMessage.delete(messages[index]['message_id']);
                                                                      // Perform any action here, like navigating to a new screen
                                                                    }
                                                                  },
                                                                  child: AnimatedContainer(
                                                                    duration: const Duration(milliseconds: 300),
                                                                    curve: Curves.easeInOut,
                                                                    constraints:
                                                                        const BoxConstraints(
                                                                            maxWidth:
                                                                                450),
                                                                    decoration: BoxDecoration(
                                                                        color: CupertinoColors
                                                                            .activeBlue,
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    10)),
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            right: 20,
                                                                            top: 10,
                                                                            bottom:
                                                                                10),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                12,
                                                                            vertical:
                                                                                8),
                                                                    child: Text(
                                                                        messages[
                                                                                index]
                                                                            [
                                                                            'message_content'],
                                                                        maxLines:
                                                                            null,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white)),
                                                                  ),
                                                                )
                                                              ]),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                                margin: const EdgeInsets.only(right: 25,bottom: 10),
                                                                child:  Row(
                                                                  children: [
                                                                    Text('Replied by:'),
                                                                    const SizedBox(width: 5,),
                                                                    Text(messages[index]['sender_name'])
                                                                  ],
                                                                )
                                                            )
                                                          ],
                                                        )

                                                      ],
                                                    );
                                              },
                                            )
                                          : noMessages?  const Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.warning),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "No messages found",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ):const Center(
                                              child: CircularProgressIndicator(),
                                            )
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
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
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
        : const Column(
      mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator()),

             SizedBox(height: 20),
             Text("Loading..." , style: TextStyle(fontSize: 20)),
          ],
        );
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
  String selectedEmployee = "";
  late ScrollController _scrollController;
}
