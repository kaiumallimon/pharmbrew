import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/controllers/dropdown_controller.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pharmbrew/data/_attendance_absent.dart';
import 'package:pharmbrew/data/_attendance_checkin_checkout.dart';
import 'package:pharmbrew/data/_get_attendace.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/_fetch_attendance_stats.dart';
import '../../../data/_fetch_employee.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final listDropdownController1 = DropdownController();
  final listDropdownController2 = DropdownController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  dynamic selectedEmployee = {};

  late Timer timer;
  List<dynamic> employees = [];
  List<int> expandedRows =
      []; // List to store the indices of rows with expanded actions

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    searchController2.dispose();
    timer.cancel();
    timer1.cancel();
    timer2.cancel();
    timer3.cancel();
    timer4.cancel();
  }

  List<dynamic> absents=[];

  late Timer timer1, timer2, timer3, timer4;

  @override
  void initState() {
    super.initState();

    timer1 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchEmployees(null, null);
    });

    timer2 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchAttendance();
    });

    timer3 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchAttendanceStatsIndividual(selectedEmployee['userId']);
    });

    timer4=Timer.periodic(const Duration(milliseconds: 500), (timer) {
     if(selectedEmployee.isNotEmpty){
       fetchAbsent();
     }
    });

  }

  void reload() {
    setState(() {
      fetchEmployees(null, null);
    });
  }

  void fetchAbsent() async{
    List<dynamic> localAbsent=await fetchAttendanceAbsents(selectedEmployee['userId']);
    setState(() {
      absents=localAbsent;
    });

    print("Absent list: $absents");
  }

  void fetchEmployees(String? orderBy, String? order) async {
    var result = await FetchEmployee.fetchEmployee(orderBy, order);
    setState(() {
      employees = result;
    });
  }

  List<dynamic> employeeAttendances = [];

  void fetchAttendance() async {
    var result = await GetAttendance.get();
    setState(() {
      employeeAttendances = result;
    });
  }

  List<dynamic> searchList = [];

  void searchEmployee(String query) {
    setState(() {
      if (query.isEmpty) {
        searchList = [];
      } else {
        searchList = employees.where((employee) {
          String name = employee['name'].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void toggleActionExpansion(int index) {
    setState(() {
      if (expandedRows.contains(index)) {
        expandedRows.remove(index);
      } else {
        expandedRows.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attendance',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Dashboard / Attendance',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(right: 50),
                        child: Text(
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          inFocus = 0;
                        });
                      },
                      child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: inFocus == 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Take',
                          style: TextStyle(
                              color: inFocus == 0 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          inFocus = 1;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: inFocus == 1
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                              color: inFocus == 1 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                ),
                const SizedBox(height: 40),
                inFocus == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: 600,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: searchController2,
                              onChanged: (value) {
                                searchEmployee(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search Employees',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.grey.shade500),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          employees.isEmpty
                              ? const Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    DataTable(
                                      dividerThickness: 1,
                                      border: TableBorder.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      dataRowHeight: 150,
                                      headingRowColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary;
                                      }),
                                      headingTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      columns: const [
                                        DataColumn(label: Text('Picture')),
                                        DataColumn(label: Text('Employee ID')),
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Status')),
                                        DataColumn(
                                            label: Text('Check-In Time')),
                                        DataColumn(
                                            label: Text('Check-Out Time')),
                                        DataColumn(label: Text('Action')),
                                      ],
                                      rows: (searchController2.text.isEmpty
                                              ? employees
                                              : searchList)
                                          .asMap()
                                          .entries
                                          .map<DataRow>((entry) {
                                        int rowIndex =
                                            searchController2.text.isEmpty
                                                ? employees.indexOf(entry.value)
                                                : entry.key;
                                        dynamic employee = entry.value;
                                        bool isExpanded =
                                            expandedRows.contains(rowIndex);
                                        return DataRow(cells: [
                                          DataCell(
                                            SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: CachedNetworkImage(
                                                imageUrl: getImageLink(
                                                    employee['profile_pic']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(employee['userId'])),
                                          DataCell(Text(employee['name'])),
                                          DataCell(Text(getAttendanceStatus(
                                              employee['userId']))),
                                          DataCell(Text(getCheckInTime(
                                              employee['userId']))),
                                          DataCell(Text(getCheckOutTime(
                                              employee['userId']))),
                                          DataCell(
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedEmployee =
                                                          employee;
                                                    });
                                                    toggleActionExpansion(
                                                        rowIndex);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // print(
                                                        //     "Attendacne: ${getAttendanceStatus(employee['userId'])}");
                                                        toggleActionExpansion(
                                                            rowIndex);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.black,
                                                        visualDensity:
                                                            VisualDensity
                                                                .comfortable,
                                                      ),
                                                      child: isExpanded
                                                          ? const Icon(
                                                              Icons.close)
                                                          : const Text(
                                                              'Take Attendance',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                isExpanded
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 130,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: isCheckedIn(
                                                                      employee[
                                                                          'userId'])
                                                                  ? null
                                                                  : () async {
                                                                      bool result = await TakeAttendance.checkIn(
                                                                          employee[
                                                                              'userId'],
                                                                          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                                          '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                                                          'Present');
                                                                      //
                                                                      // print(
                                                                      //     'Attendance: $result');

                                                                      if (result) {
                                                                        showCustomSuccessDialog(
                                                                            'Check-In Successful!',
                                                                            context);
                                                                      } else {
                                                                        showCustomSuccessDialog(
                                                                            'Check-In Failed!',
                                                                            context);
                                                                      }
                                                                    },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              child: const Text(
                                                                  'Check-In'),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          SizedBox(
                                                            width: 130,
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed: isCheckedOut(employee['userId']) ||
                                                                            getAttendanceStatus(employee['userId']) ==
                                                                                'Absent' ||
                                                                            !isCheckedIn(employee[
                                                                                'userId'])
                                                                        ? null
                                                                        : () async {
                                                                            //send check-out request to the server

                                                                            bool
                                                                                result =
                                                                                await TakeAttendance.checkout(employee['userId'], '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}', '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                                                                            if (result) {
                                                                              showCustomSuccessDialog('Check-Out Successful!', context);
                                                                            } else {
                                                                              showCustomSuccessDialog('Check-Out Failed!', context);
                                                                            }
                                                                          },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blueAccent,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: const Text(
                                                                        'Check-Out')),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          SizedBox(
                                                            width: 130,
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed: getAttendanceStatus(employee['userId']) ==
                                                                                'Present' ||
                                                                            getAttendanceStatus(employee['userId']) ==
                                                                                'Absent'
                                                                        ? null
                                                                        : () async {
                                                                            //send absent request to the server
                                                                            bool
                                                                                result =
                                                                                await AbsentAttendance.set(employee['userId'], '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');
                                                                            if (result) {
                                                                              showCustomSuccessDialog("${employee['name']} marked as absent!!", context);
                                                                            } else {
                                                                              showCustomSuccessDialog('Failed to mark as absent!', context);
                                                                            }
                                                                          },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: const Text(
                                                                        'Absent')),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ],
                                )
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              selectedEmployee.isEmpty
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      width: 600,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          searchEmployee(value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Search Employees',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade500),
                                          prefixIcon: Icon(Icons.search,
                                              color: Colors.grey.shade500),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                height: 60,
                                                width: 60,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: getImageLink(
                                                        selectedEmployee[
                                                            'profile_pic']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    selectedEmployee['userId'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    selectedEmployee['name'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedEmployee = {};
                                                    selectedDate = '';
                                                  });
                                                },
                                                icon: const Icon(Icons.close,
                                                    color: Colors.red),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: DropdownButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            underline: const SizedBox.shrink(),
                                            dropdownColor: Colors.grey.shade300,
                                            hint: Text(selectedDate.isNotEmpty
                                                ? selectedDate
                                                : 'Select Date'),
                                            items: _buildDropdownMenuItems(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDate = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 20),
                          searchController.text.isNotEmpty
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 600,
                                      height: 300,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchList.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedEmployee =
                                                        searchList[index];
                                                  });

                                                  // fetchAttendanceStatsIndividual(
                                                  //     selectedEmployee[
                                                  //         'userId']);
                                                  searchController.clear();
                                                },
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: getImageLink(
                                                              searchList[index][
                                                                  'profile_pic']),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(searchList[index]
                                                              ['userId']),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                            searchList[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            searchList[index]
                                                                ['designation'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),


                          selectedDate.isNotEmpty ? TableCalendar(
                            headerStyle: HeaderStyle(
                              headerMargin: const EdgeInsets.only(bottom: 20),
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              // todayDecoration: BoxDecoration(
                              //   color: absents.contains(DateTime.now().toString().split(" ")[0])?Colors.red: Theme.of(context).colorScheme.primary,
                              //   shape: BoxShape.circle,
                              // ),
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              todayTextStyle: const TextStyle(
                                color: Colors.white,
                              ),

                            ),
                            onDaySelected: (date, focusedDate) {
                              setState(() {
                                selectedCalendarValue = date;
                              });
                              print('Selected day: $selectedCalendarValue');
                            },
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, _) {
                                String formattedDate = DateFormat('yyyy-MM-dd').format(day);
                                bool isCurrentDateAbsent = isAbsent(formattedDate);
                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontWeight: isCurrentDateAbsent ? FontWeight.bold : FontWeight.normal,
                                      color: isCurrentDateAbsent ? Colors.red : Colors.black, // Change text color to red if absent
                                    ),
                                  ),
                                );
                              },
                            ),
                            currentDay: selectedCalendarValue,
                            focusedDay: DateTime.utc(
                              getFirstDayOfMonth(selectedDate)[0],
                              getFirstDayOfMonth(selectedDate)[1],
                              getFirstDayOfMonth(selectedDate)[2],
                            ),
                            firstDay: DateTime.utc(
                              getFirstDayOfMonth(selectedDate)[0],
                              getFirstDayOfMonth(selectedDate)[1],
                              getFirstDayOfMonth(selectedDate)[2],
                            ),
                            lastDay: DateTime.utc(
                              getLastDayOfMonth(selectedDate)[0],
                              getLastDayOfMonth(selectedDate)[1],
                              getLastDayOfMonth(selectedDate)[2],
                            ),
                          ) : Container(
                            height: 300,
                            width: 300,
                            child: Text('Select a date to view attendance'),
                          )



                        ],
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getImageLink(String? image) {
    if (image == null || image.isEmpty) {
      return ''; // Return an empty string if no image is provided
    }
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/$image";
    return imageUrl;
  }

  String getAttendanceStatus(String userId) {
    for (var attendance in employeeAttendances) {
      if (attendance['userId'] == userId && checkDate(attendance['date'])) {
        return attendance['status'];
      }
    }
    return 'Yet to Check-In';
  }

  bool isCheckedIn(String userId) {
    for (var attendance in employeeAttendances) {
      if (attendance['userId'] == userId && checkDate(attendance['date'])) {
        return true;
      }
    }
    return false;
  }

  bool isCheckedOut(String userId) {
    for (var attendance in employeeAttendances) {
      if (attendance['userId'] == userId && checkDate(attendance['date'])) {
        if (attendance['checkOutTime'] != null) {
          return true;
        }
      }
    }
    return false;
  }

  String getCheckInTime(String userId) {
    for (var attendance in employeeAttendances) {
      if (attendance['userId'] == userId && checkDate(attendance['date'])) {
        String? time = attendance['checkInTime'];
        print('Checkin Time: $time');
        if (time != null && time != 'null') {
          return convertTo12HourFormat(time);
        } else {
          return '-';
        }
      }
    }
    return 'Yet to Check-In';
  }

  String getCheckOutTime(String userId) {
    for (var attendance in employeeAttendances) {
      if (attendance['userId'] == userId && checkDate(attendance['date'])) {
        String? time = attendance['checkOutTime'];
        String? status = attendance['status'];
        if (time != null && status == 'Present') {
          return convertTo12HourFormat(time);
        } else {
          if (status == 'Absent') {
            return '-';
          } else {
            return 'Yet to Check-Out';
          }
        }
      }
    }
    return 'Yet to Check-In';
  }

  String convertTo12HourFormat(String twentyFourHourTime) {
    final format24 = DateFormat.Hm();
    final dateTime24 = format24.parse(twentyFourHourTime);

    final format12 = DateFormat.jm();
    final twelveHourTime = format12.format(dateTime24);

    return twelveHourTime;
  }

  List<dynamic> filteredEmployees(List<dynamic> employees, String query) {
    if (query.isEmpty) {
      return employees;
    }

    return employees.where((employee) {
      return employee['name'].toLowerCase().contains(query.toLowerCase()) ||
          employee['email'].toLowerCase().contains(query.toLowerCase()) ||
          employee['userId'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  bool checkDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      String formattedDate =
          "${parsedDate.year}-${parsedDate.month}-${parsedDate.day}";
      DateTime now = DateTime.now();
      String today = "${now.year}-${now.month}-${now.day}";
      return formattedDate == today;
    } catch (e) {
      return false;
    }
  }

  int inFocus = 0;
  DropdownController yearController = DropdownController();

  List<dynamic> attendanceStatsIndividual = [];

  void fetchAttendanceStatsIndividual(String userId) async {
    var response = await FetchAttendanceStatsIndividual.fetch();
    // print("Response $response");

    attendanceStatsIndividual.clear(); // Clear existing data

    for (var attendance in response) {
      if (attendance['userId'] == userId) {
        setState(() {
          attendanceStatsIndividual.add(attendance);
          print('Attendance added to list');
        });
      }
    }

    print('Attendance Stats: $attendanceStatsIndividual');
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    List<String> years = []; // Your dynamic list of years

    for (var attendance in attendanceStatsIndividual) {
      years.add(attendance['month']);
    }

    return years.map((String year) {
      return DropdownMenuItem(
        value: year,
        child: Text(year),
      );
    }).toList();
  }

  List<int> getFirstDayOfMonth(String monthYear) {
    // Parse the month and year from the input string
    List<String> parts = monthYear.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);


    return [year, month, 1];
  }

  List<int> getLastDayOfMonth(String monthYear) {
    List<String> parts = monthYear.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    DateTime lastDayOfNextMonth =
        DateTime(year, month + 1, 1).subtract(Duration(days: 1));
    List parts2 = lastDayOfNextMonth.toString().split(' ');
    String lastDay = parts2[0];

    List<int> date = [];

    List parts3 = lastDay.split('-');
    date.add(int.parse(parts3[0]));
    date.add(int.parse(parts3[1]));
    date.add(int.parse(parts3[2]));

    return date;
  }

  String selectedDate = '';

  DateTime selectedCalendarValue = DateTime.now();

  String getEventLoader(DateTime day){
    String fYear=day.year.toString();
    String fMonth=day.month.toString();
    String fDay=day.day.toString();

    if(fMonth.length==1){
      fMonth='0$fMonth';
    }

    if(fDay.length==1){
      fDay='0$fDay';
    }

    String formattedEventLoader='$fYear-$fMonth-$fDay';

    return formattedEventLoader;
  }


  bool isAbsent(String date){
    print('Given Date: $date');
    print("Result: ${absents.contains(date)}  ");
    if(absents.contains(date)){
      return true;
    }else{
      return false;
    }
  }
}
