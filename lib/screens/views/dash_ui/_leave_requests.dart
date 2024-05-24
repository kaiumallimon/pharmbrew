import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_approve_leave_request.dart';
import 'package:pharmbrew/data/_fetch_leave_requests.dart';
import 'package:pharmbrew/utils/_show_dialog2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/_show_dialog.dart';

class LeaveRequests extends StatefulWidget {
  const LeaveRequests({super.key});

  @override
  State<LeaveRequests> createState() => _LeaveRequestsState();
}

class _LeaveRequestsState extends State<LeaveRequests> {
  int selectedOption = 0;
  bool isInitialOpening = true;
  bool isInitialOpening2 = true;

  List<dynamic> allPendingRequests = [];
  List<dynamic> approvedPendingRequests = [];

  void fetchAllLeaveRequests() async {
    var data = await FetchLeaveRequestData.fetchAll();
    setState(() {
      allPendingRequests = data;
    });
  }

  void fetchApprovedLeaveRequests() async {
    var data = await FetchLeaveRequestData.fetchApproved();
    setState(() {
      approvedPendingRequests = data;
    });
  }

  late String userId = '';
  late Timer timer1;
  late Timer timer2;

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('loggedInUserId') ??
          ''; // Assign x to pp, if x is null assign an empty string
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();

    Future.delayed(Duration(milliseconds: 500), () {
      // Fetch data from API
      setState(() {
        isInitialOpening = false;
      });
    });

    Future.delayed(Duration(milliseconds: 500), () {
      // Fetch data from API
      setState(() {
        isInitialOpening2 = false;
      });
    });

    timer1 = Timer.periodic(Duration(milliseconds: 300), (timer) {
      fetchAllLeaveRequests();
    });

    timer2 = Timer.periodic(Duration(milliseconds: 300), (timer) {
      fetchApprovedLeaveRequests();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer1.cancel();
    timer2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leave Requests',
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
                            selectedOption = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedOption == 0
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Pending',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedOption == 0
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
                            selectedOption = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedOption == 1
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Approved/Rejected',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedOption == 1
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
              selectedOption == 0
                  ? Expanded(
                      child: isInitialOpening
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              child: allPendingRequests.isEmpty
                                  ? const Center(
                                      child: Text("No pending requests found!"),
                                    )
                                  : ListView.builder(
                                      itemCount: allPendingRequests.length,
                                      itemBuilder: (context, index) {
                                        return MouseRegion(
                                          onEnter: (_) {
                                            setState(() {
                                              hoveredRequest = index;
                                            });
                                          },
                                          onExit: (_) {
                                            setState(() {
                                              hoveredRequest = -1;
                                            });
                                          },
                                          child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                  color: hoveredRequest == index
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 2)),
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: getImageLink(
                                                        allPendingRequests[
                                                                index]
                                                            ['profile_pic']),
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      allPendingRequests[index]
                                                          ['name'],
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Requested on',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          allPendingRequests[
                                                                      index][
                                                                  'request_date']
                                                              .toString()
                                                              .split(" ")[0],
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Leave Type',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          allPendingRequests[
                                                                  index]
                                                              ['leave_type'],
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${countDaysBetween(DateTime.parse(allPendingRequests[index]['start_date']), DateTime.parse(allPendingRequests[index]['end_date'])) + 1}",
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Day(s)",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 13),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          allPendingRequests[
                                                                          index]
                                                                      [
                                                                      'start_date'] ==
                                                                  allPendingRequests[
                                                                          index]
                                                                      [
                                                                      'end_date']
                                                              ? "Leave date"
                                                              : 'Leave period',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          allPendingRequests[
                                                                          index]
                                                                      [
                                                                      'start_date'] ==
                                                                  allPendingRequests[
                                                                          index]
                                                                      [
                                                                      'end_date']
                                                              ? "${allPendingRequests[index]['start_date']}"
                                                              : "${allPendingRequests[index]['start_date']} to ${allPendingRequests[index]['end_date']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // width: 100,
                                                      // height: 100,
                                                      // alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Leave reason',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              alignment: Alignment
                                                                  .center,
                                                              width: 200,
                                                              child: Tooltip(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          30,
                                                                      vertical:
                                                                          20),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              400),
                                                                  message: allPendingRequests[
                                                                          index]
                                                                      [
                                                                      'reason'],
                                                                  child: Text(
                                                                    allPendingRequests[
                                                                            index]
                                                                        [
                                                                        'reason'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          child: ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(
                                                                        () {
                                                                      isInitialOpening =
                                                                      true;
                                                                    });
                                                                bool result = await ApproveLeaveRequest.approve(
                                                                    "Approved",
                                                                    userId,
                                                                    DateTime.now()
                                                                        .toString(),
                                                                    allPendingRequests[index]['requestId']
                                                                        .toString());

                                                                if (result) {
                                                                  setState(
                                                                          () {
                                                                        isInitialOpening =
                                                                        false;
                                                                      });
                                                                  showCustomSuccessDialog(
                                                                      'Request accepted successfully!',
                                                                      context);
                                                                } else {
                                                                  setState(
                                                                          () {
                                                                        isInitialOpening =
                                                                        false;
                                                                      });
                                                                  showCustomErrorDialog(
                                                                      'Failed to accept request!',
                                                                      context);
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      CupertinoColors
                                                                          .activeGreen,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10))),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .check),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      'Approve'),
                                                                ],
                                                              )),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          child: ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(
                                                                        () {
                                                                      isInitialOpening =
                                                                      true;
                                                                    });
                                                                bool result = await ApproveLeaveRequest.approve(
                                                                    "Rejected",
                                                                    userId,
                                                                    DateTime.now()
                                                                        .toString(),
                                                                    allPendingRequests[index]['requestId']
                                                                        .toString());

                                                                if (result) {
                                                                  setState(
                                                                          () {
                                                                        isInitialOpening =
                                                                        false;
                                                                      });
                                                                  showCustomSuccessDialog(
                                                                      'Request rejected successfully!',
                                                                      context);
                                                                } else {
                                                                  setState(
                                                                          () {
                                                                        isInitialOpening =
                                                                        false;
                                                                      });
                                                                  showCustomErrorDialog(
                                                                      'Failed to reject request, Please try again later!',
                                                                      context);
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      CupertinoColors
                                                                          .systemRed,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10))),
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(Icons
                                                                      .close),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                      'Reject'),
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    )))
                  : Expanded(
                      child: isInitialOpening2
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              child: approvedPendingRequests.isEmpty
                                  ? Center(
                                      child: Text(
                                          "No approved/rejected requests found!"),
                                    )
                                  : ListView.builder(
                                      itemCount: approvedPendingRequests.length,
                                      itemBuilder: (context, index) {
                                        return MouseRegion(
                                          onEnter: (_) {
                                            setState(() {
                                              hoveredRequest2 = index;
                                            });
                                          },
                                          onExit: (_) {
                                            setState(() {
                                              hoveredRequest2 = -1;
                                            });
                                          },
                                          child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                  color:
                                                      hoveredRequest2 == index
                                                          ? Colors.grey.shade200
                                                          : Colors.white,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 2)),
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: getImageLink(
                                                        approvedPendingRequests[
                                                                index]
                                                            ['profile_pic']),
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      approvedPendingRequests[
                                                          index]['name'],
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Requested on',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                                      index][
                                                                  'request_date']
                                                              .toString()
                                                              .split(" ")[0],
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Leave Type',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                                  index]
                                                              ['leave_type'],
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Checked on',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                                      index][
                                                                  'approval_date']
                                                              .toString()
                                                              .split(" ")[0],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Checked by',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                                  index][
                                                              'approved_by_name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    height: 100,
                                                    // alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          approvedPendingRequests[
                                                                          index]
                                                                      [
                                                                      'start_date'] ==
                                                                  approvedPendingRequests[
                                                                          index]
                                                                      [
                                                                      'end_date']
                                                              ? "Leave date"
                                                              : 'Leave period',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                                          index]
                                                                      [
                                                                      'start_date'] ==
                                                                  approvedPendingRequests[
                                                                          index]
                                                                      [
                                                                      'end_date']
                                                              ? "${approvedPendingRequests[index]['start_date']}"
                                                              : "${approvedPendingRequests[index]['start_date']} to ${approvedPendingRequests[index]['end_date']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // width: 100,
                                                      // height: 100,
                                                      // alignment: Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Leave reason',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              alignment: Alignment
                                                                  .center,
                                                              width: 200,
                                                              child: Tooltip(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          30,
                                                                      vertical:
                                                                          20),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              400),
                                                                  message: approvedPendingRequests[
                                                                          index]
                                                                      [
                                                                      'reason'],
                                                                  child: Text(
                                                                    approvedPendingRequests[
                                                                            index]
                                                                        [
                                                                        'reason'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts.inter(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    // duration: Duration(milliseconds: 300),
                                                    // curve: Curves.easeInOut,
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Status',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          approvedPendingRequests[
                                                              index]['STATUS'],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                              color: approvedPendingRequests[
                                                                              index]
                                                                          [
                                                                          'STATUS'] ==
                                                                      "Approved"
                                                                  ? CupertinoColors.activeGreen
                                                                  : Colors.red),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                            ))
            ],
          ),
        ));
  }

  String getImageLink(String? image) {
    if (image == null || image.isEmpty) {
      return ''; // Return an empty string if no image is provided
    }
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/$image";
    return imageUrl;
  }

  int countDaysBetween(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      DateTime temp = start;
      start = end;
      end = temp;
    }

    return end.difference(start).inDays;
  }

  String convertTo12HourFormat(String time24) {
    // Split the time string into hours and minutes
    List<String> parts = time24.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Determine AM or PM
    String period = hours >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hours = hours % 12;
    if (hours == 0) {
      hours = 12;
    }

    // Format the time
    String time12 = '$hours:$minutes $period';
    return time12;
  }

  int approveHoveredIndex = -1;
  int rejectHoveredIndex = -1;
  int hoveredRequest = -1;
  int hoveredRequest2 = -1;
}
