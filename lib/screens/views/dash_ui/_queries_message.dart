import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../data/_fetch_employee_data.dart';
import '../../../data/_fetch_senders.dart';

class Queries extends StatefulWidget {
  const Queries({super.key});

  @override
  State<Queries> createState() => _QueriesState();
}

class _QueriesState extends State<Queries> {
  bool isChatOpen = false;
  late Timer timer;
  List<Map<String, dynamic>> senders = [];

  @override
  void initState() {
    super.initState();
    print('Init state');
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Call setState to update the UI
      setState(() {
        fetchData();
        print('refreshed');
      });
    });
    print('Data fetched');
    print(senders);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void fetchData() async {
    List<dynamic> fetchedSenders = await FetchSenders.fetchEmployee();
    List senderIDs =
        fetchedSenders.map((sender) => sender['sender_id']).toList();

    print('Sender IDs: $senderIDs');

    List<Map<String, dynamic>> loadedSenders = [];
    for (var senderID in senderIDs) {
      Map<String, dynamic> employeeData =
          await FetchEmployeeData.fetchEmployee(senderID);
      String id = employeeData['userId'];
      String name = employeeData['name'];
      String profilePic = employeeData['profile_pic'];
      String designation= employeeData['designation'];

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
    print('Data fetched');
    print(senders);
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
                    // Header
                    Text(
                      "Queries",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Query list (left side)
                          Expanded(
                            child: Column(
                              children: [
                                //searchbar:

                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 400,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Search',
                                            prefixIcon: Icon(Icons.search),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: senders.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              isChatOpen = true;
                                              inFocusSender = senders[index]['id'];
                                              selectedChatData = senders[index]; // Store selected chat data
                                              print(selectedChatData);
                                            });
                                            // Load chat data here if necessary
                                          },
                                          child: Container(
                                            color:Colors.white,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin: const EdgeInsets.only(
                                                          bottom: 5),
                                                      padding:
                                                          const EdgeInsets.all(10),
                                                      // color: Colors.red,
                                                      child: Row(
                                                        children: [
                                                          //profile image
                                                          Container(
                                                            child: CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              backgroundImage:
                                                                  CachedNetworkImageProvider(
                                                                getImageLink(
                                                                  senders[index][
                                                                      'profilePic'],
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          //profile name
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
                                                                    EdgeInsets.only(
                                                                        left: 10),
                                                                child: Text(
                                                                  senders[index]
                                                                      ['name'],
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // index==senders.length-1?

                                        // SizedBox.shrink():

                                        Divider(
                                          color: Colors.grey,
                                        ),
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Chat display (right side)

                          !isChatOpen
                              ? Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      // Chat header
                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                                //profile image
                                                Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(getImageLink(selectedChatData['profilePic'])),
                                                  ),
                                                ),

                                                //profile name
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.only(left: 10),
                                                      child: Text(
                                                        selectedChatData['name'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.only(left: 10),
                                                      child: Text(
                                                        selectedChatData['designation'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            IconButton(onPressed: (){
                                              setState(() {
                                                isChatOpen = false;
                                              });

                                            }, icon: Icon(Icons.close)),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      //body:
                                      Container(
                                          color: Colors.grey.shade200,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              250),

                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      //footer:

                                      Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                decoration: BoxDecoration(
                                                  // color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextField(
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
                                                // Handle sending a message
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
                        ])
                  ],
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  String getImageLink(String? image) {
    if (image == null || image.isEmpty) {
      return 'https://placehold.co/600x400/png'; // Return an empty string if no image is provided
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
}
