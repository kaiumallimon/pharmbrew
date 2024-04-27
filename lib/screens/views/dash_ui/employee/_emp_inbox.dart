import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmbrew/data/_delete_message.dart';
import 'package:pharmbrew/data/_send_message_to_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/_fetch_messages.dart';

class EmployeeInbox extends StatefulWidget {
  const EmployeeInbox({Key? key}) : super(key: key);

  @override
  State<EmployeeInbox> createState() => _EmployeeInboxState();
}

class _EmployeeInboxState extends State<EmployeeInbox> {
  dynamic messages = [];

  late String userId = '';

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('loggedInUserId') ?? '';
    });
  }

  late Timer timer;

  @override
  void initState() {
    super.initState();
    initData();
    timer = Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => fetchMessage());
    _scrollController = ScrollController();
  }

  void fetchMessage() async {
    if (userId.isNotEmpty) {
      var response = await FetchMessages.fetch(userId);

      if (response is! Map<String, dynamic>) {
        setState(() {
          messages = response;
        });
        // Scroll to the bottom after updating the messages
        scrollToBottom();
      } else {
        // Show the circular progress indicator for 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        if (messages.isEmpty) {
          // If still no data, display a centered message
          setState(() {
            messages = [];
          });
        }
      }


      // print(response);
    }

    if(!fetched){
      setState(() {
        fetched=true;
      });
    }
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: const Row(
                  children: [
                    Text('Support',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orangeAccent,
                              ),
                              child: const Icon(Icons.support_agent,
                                  size: 30.0, color: Colors.black),
                            ),
                            const SizedBox(width: 10.0),
                            const Text('Administrator',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.74,
                        child: messages.isNotEmpty
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return messages[index]['send_by'] ==
                                          'employee'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                constraints: const BoxConstraints(
                                                    maxWidth: 450),
                                                decoration: BoxDecoration(
                                                  color:
                                                      CupertinoColors.activeBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    left: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  messages[index]
                                                      ['message_content'],
                                                  maxLines: null,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                constraints: const BoxConstraints(
                                                    maxWidth: 450),
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .orangeAccent.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    right: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                child: Text(
                                                  messages[index]
                                                      ['message_content'],
                                                  maxLines: null,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              )
                            : fetched?Center(
                                child: Text(
                                  'No messages yet',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ):const Center(
                                child: CircularProgressIndicator(),
                              ),

                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50.0,
                                // Set a fixed height for the text field
                                child: TextField(
                                  controller: messageController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    hintText: 'Type a message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 50.0,
                              // Set a fixed width for the send button
                              child: IconButton(
                                onPressed: () {
                                  String text =
                                      messageController.text.toString().trim();

                                  if (text.isNotEmpty) {
                                    SendMessageToAdmin.send(userId, text);
                                    messageController.clear();
                                  }
                                },
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool fetched=false;
  TextEditingController messageController = TextEditingController();
  late ScrollController _scrollController;
}
