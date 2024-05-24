import 'dart:async';
import 'dart:ui';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_fetch_leave_requests.dart';
import 'package:pharmbrew/data/_insert_leave_request.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/utils/_show_dialog2.dart';
import 'package:pharmbrew/widgets/_custom_success2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeLeaveRequest extends StatefulWidget {
  const EmployeeLeaveRequest({super.key});

  @override
  State<EmployeeLeaveRequest> createState() => _EmployeeLeaveRequestState();
}

class _EmployeeLeaveRequestState extends State<EmployeeLeaveRequest> {
  int selectedIndex = 0;
  int hoveringIndex = -1;
  bool isHoveringRefresh = false;
  bool isHovering1 = false;
  bool isHovering2 = false;
  bool isHoveringSendButton = false;
  String? selectedType;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  late Timer timer1;
  bool isLoadingData = false;

  bool isLoading = false;
  late String userId = '';
  final typeController = DropdownController();
  final List<String> types = <String>[
    'Sick',
    'Vacation',
    'Personal',
    'Unpaid',
    'Other'
  ];
  List<CoolDropdownItem<String>> typesList = [];
  final TextEditingController descriptionController = TextEditingController();

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('loggedInUserId') ??
          ''; // Assign x to pp, if x is null assign an empty string
    });
  }

  bool isInitialOpen = true;

  List<dynamic> leaveRequests = [];

  void fetchLeaves() async {
    setState(() {
      isLoadingData = true;
    });
    if (userId == null || userId.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500));
    }
    List<dynamic> local = await FetchLeaveRequestData.fetch(userId);
    setState(() {
      leaveRequests = local;
      isLoadingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();

    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        isInitialOpen = false;
      });
    });

    timer1 = Timer(Duration(milliseconds: 500), () {
      fetchLeaves();
    });
    for (var x in types) {
      typesList.add(CoolDropdownItem<String>(value: x, label: x));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer1.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Request',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 400,
              height: 40,
              // color: Colors.red,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });

                        fetchLeaves();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'View All Requests',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Request for leave',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            selectedIndex == 0
                ? Expanded(
                    //view
                    child: isInitialOpen
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            // decoration: BoxDecoration(
                            //   color: Colors.grey.shade300,
                            // ),
                            child: leaveRequests.isEmpty
                                ? const Center(
                                    child: Text('No leave requests found!'),
                                  )
                                : Container(
                                    child: isLoadingData
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'All requests',
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      leaveRequests.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return MouseRegion(
                                                      onEnter: (event){
                                                        setState(() {
                                                          selectedRequest=index;
                                                        });
                                                      },
                                                      onExit: (event){
                                                        setState(() {
                                                          selectedRequest=-1;
                                                        });
                                                      },
                                                      child: AnimatedContainer(
                                                        duration: Duration(milliseconds: 300),
                                                        curve: Curves.easeInOut,
                                                        margin: EdgeInsets.only(
                                                            bottom: 20),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey.shade300,
                                                            width: 2
                                                          ),
                                                            color: selectedRequest==index? Colors.grey.shade300 : Colors.white),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 50,
                                                                  width: 100,
                                                                  child: Column(
                                                                    children: [
                                                                     const Text(
                                                                        'Requested on:',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        leaveRequests[index]
                                                                                [
                                                                                'request_date']
                                                                            .toString()
                                                                            .split(
                                                                                ' ')
                                                                            .first,
                                                                        style: GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                AnimatedContainer(
                                                                  duration: Duration(milliseconds: 300),
                                                                  curve: Curves.easeInOut,
                                                                  width: selectedRequest==index? 4 : 2,
                                                                  height: 50,
                                                                  color: selectedRequest==index? Colors.black : Colors
                                                                      .grey
                                                                      .shade500,
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: CupertinoColors
                                                                          .activeOrange,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              30),
                                                                  child: Text(
                                                                    leaveRequests[
                                                                            index]
                                                                        [
                                                                        'leave_type'],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Container(
                                                                  width: 150,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration: BoxDecoration(
                                                                      color: CupertinoColors
                                                                          .systemPurple,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8,
                                                                          horizontal:
                                                                              30),
                                                                  child: Text(
                                                                    "${countDaysBetween(DateTime.parse(leaveRequests[index]['start_date']), DateTime.parse(leaveRequests[index]['end_date'])) + 1} Day (s)",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Container(
                                                                  // width: 150,
                                                                  alignment:
                                                                  Alignment
                                                                      .center,
                                                                  decoration: BoxDecoration(
                                                                      color: CupertinoColors
                                                                          .activeBlue,
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          10)),
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                      8,
                                                                      horizontal:
                                                                      30),
                                                                  child: Text(
                                                                    leaveRequests[index]['start_date']==leaveRequests[index]['end_date']?"Leave Date: ${leaveRequests[index]['start_date']}":"Leave Period: ${leaveRequests[index]['start_date']} to ${leaveRequests[index]['end_date']}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),

                                                                Expanded(child: Container(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [Container(
                                                                      width: 150,
                                                                      alignment:
                                                                      Alignment
                                                                          .center,
                                                                      decoration: BoxDecoration(
                                                                          color: leaveRequests[index]['STATUS']=='Pending'? Colors.grey.shade800:leaveRequests[index]['STATUS']=='Approved'? CupertinoColors.activeGreen : Colors.red,
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                          8,
                                                                          horizontal:
                                                                          30),
                                                                      child: Text(
                                                                        leaveRequests[index]['STATUS'],
                                                                        style: const TextStyle(
                                                                            color: Colors.white),
                                                                      ),
                                                                    ),],
                                                                  ),
                                                                ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )),
                          ))
                : isLoading
                    ? const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Sending Request...'),
                        ],
                      ))
                    : Expanded(
                        //form

                        child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Request For Leave',
                                style: GoogleFonts.interTight(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: 250,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      alignment: Alignment.center,
                                      elevation: 8,
                                      dropdownColor: Colors.green[100],
                                      icon: const Icon(Icons.arrow_drop_down),
                                      hint: const Text('Select Request Type'),
                                      value: selectedType,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedType = newValue!;
                                        });
                                      },
                                      items: types
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (event) {
                                    setState(() {
                                      isHovering1 = true;
                                    });
                                  },
                                  onExit: (event) {
                                    setState(() {
                                      isHovering1 = false;
                                    });
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? localDate1 = await _selectDate(
                                          context, DateTime.now());

                                      setState(() {
                                        selectedStartDate = localDate1;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 300),
                                      width: 250,
                                      height: 47,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: isHovering1
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        selectedStartDate == null
                                            ? 'Select Start Date'
                                            : selectedStartDate
                                                .toString()
                                                .split(' ')
                                                .first,
                                        style: TextStyle(
                                            color: isHovering1
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (event) {
                                    setState(() {
                                      isHovering2 = true;
                                    });
                                  },
                                  onExit: (event) {
                                    setState(() {
                                      isHovering2 = false;
                                    });
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? localDate2 = await _selectDate(
                                          context, selectedStartDate!);

                                      setState(() {
                                        selectedEndDate = localDate2;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 300),
                                      width: 250,
                                      height: 47,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: selectedStartDate == null
                                              ? Colors.grey[300]
                                              : isHovering2
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        selectedEndDate == null
                                            ? 'Select End Date'
                                            : selectedEndDate
                                                .toString()
                                                .split(' ')
                                                .first,
                                        style: TextStyle(
                                            color: selectedStartDate == null
                                                ? Colors.grey.shade700
                                                : isHovering2
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 790,
                                constraints: const BoxConstraints(
                                  minHeight: 50,
                                  maxHeight: 300,
                                ),
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  controller: descriptionController,
                                  maxLines: null,
                                  // Allow the text field to expand vertically
                                  // expands: true, // Allow the text field to expand vertically
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                    hintText:
                                        'Write the reason/description here...',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (event) {
                                  setState(() {
                                    isHoveringSendButton = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    isHoveringSendButton = false;
                                  });
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    String description = descriptionController
                                        .text
                                        .toString()
                                        .trim();
                                    if (selectedType == null ||
                                        selectedType!.isEmpty) {
                                      showCustomErrorDialog(
                                          'Please Select Leave Type!', context);
                                      return;
                                    }

                                    if (selectedStartDate == null ||
                                        selectedEndDate == null) {
                                      showCustomErrorDialog(
                                          'Date Cannot be empty!', context);
                                      return;
                                    }

                                    if (description.isEmpty) {
                                      showCustomErrorDialog(
                                          'Reason/Description cannot be empty!',
                                          context);
                                      return;
                                    }

                                    setState(
                                      () {
                                        isLoading = true;
                                      },
                                    );

                                    bool response =
                                        await InsertLeaveRequest.request(
                                            userId,
                                            selectedType!,
                                            selectedStartDate
                                                .toString()
                                                .trim()
                                                .split(' ')
                                                .first,
                                            selectedEndDate
                                                .toString()
                                                .trim()
                                                .split(' ')
                                                .first,
                                            description);

                                    if (response) {
                                      setState(() {
                                        isLoading = false;
                                        selectedType = null;
                                        selectedStartDate = null;
                                        selectedEndDate = null;
                                        descriptionController.clear();
                                      });
                                      showCustomSuccessDialog2(
                                          'Request Sent Successfully!',
                                          context);
                                    } else {
                                      showCustomErrorDialog(
                                          'Failed to send request!', context);
                                    }
                                  },
                                  child: Container(
                                    width: 790,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedContainer(
                                          curve: Curves.linear,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: 50,
                                          width: 250,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: isHoveringSendButton
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(.5)
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            'Send Request',
                                            style: TextStyle(
                                                color: isHoveringSendButton
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      lastDate: DateTime(DateTime.now().year + 10, 12),
    );
    return picked;
  }

  int countDaysBetween(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      DateTime temp = start;
      start = end;
      end = temp;
    }

    return end.difference(start).inDays;
  }

  int selectedRequest=-1;
}
