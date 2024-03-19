import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final ScrollController _scrollController = ScrollController();
  final Duration _scrollDuration = const Duration(milliseconds: 500);
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Scroll to the top initially

    initData();

    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0.0,
        duration: _scrollDuration,
        curve: Curves.easeInOut,
      );
    });
    focusNode.addListener(_onFocusChange);
  }

  late String pp = ''; // Initialize pp with an empty string
  late String name = '';
  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      pp = prefs.getString('loggedInUserProfilePic') ??
          ''; // Assign x to pp, if x is null assign an empty string

      name = prefs.getString('loggedInUserName') ??
          ''; // Assign x to pp, if x is null assign an empty string
    });
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    _scrollController.dispose(); // Dispose ScrollController
    focusNode.dispose(); // Dispose FocusNode
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
    return Column(
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
                duration: const Duration(milliseconds: 500),
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    suffixIcon: isTextFieldFocused
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(right: 5, left: 5),
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.arrow_right,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
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
                padding: const EdgeInsets.only(right: 20),
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
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://bcrypt.site/uploads/images/profile/picture/$pp'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '100',
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '100',
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
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '100',
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 600,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'More?',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Coming Soon',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
