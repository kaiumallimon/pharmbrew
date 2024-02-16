import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final ScrollController _scrollController = ScrollController();
  final Duration _scrollDuration = Duration(milliseconds: 500);
  FocusNode focusNode=FocusNode();

  @override
  void initState() {
    super.initState();
    // Scroll to the top initially
    Timer(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0.0,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );

    });
    focusNode.addListener(_onFocusChange);
  }
  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    super.dispose();
  }


  bool isTextFieldFocused = false;

  void _onFocusChange() {
    setState(() {
      isTextFieldFocused = focusNode.hasFocus;
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 200;
    return Container(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "26°C",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Dhaka, Bangladesh",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                  width: width * .33,
                  height: 50,
                  child: TextField(
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Search anything",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          CupertinoIcons.search,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      suffixIcon: isTextFieldFocused ? Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(right: 5, left: 5),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.arrow_right,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ) : null,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear,
                        child: Icon(
                          CupertinoIcons.bell_fill,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                "A",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear,
                        height: 200,
                        width: width * .31,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lorem Ipsum',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade200),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '69',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 500),
                        height: 200,
                        width: width * .31,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lorem Ipsum',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade200),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '69',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear,
                        height: 200,
                        width: width * .31,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.background,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lorem Ipsum',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '69',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'More?',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Coming Soon',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
