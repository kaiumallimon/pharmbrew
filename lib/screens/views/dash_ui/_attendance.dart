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
import 'package:syncfusion_flutter_charts/charts.dart';
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
  Map<String, dynamic> individualEmployee = {};

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

  List<dynamic> absents = [];

  late Timer timer1, timer2, timer3, timer4, timer5;

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
      fetchAttendanceStatsIndividual(individualEmployee['userId']);
    });

    timer4 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (selectedEmployee.isNotEmpty) {
        fetchAbsent();
      }
    });

    timer5 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if(searchController3.text.trim().isEmpty){
        fetchAllEmployees();
      }
    });
  }

  void reload() {
    setState(() {
      fetchEmployees(null, null);
    });
  }

  void fetchAbsent() async {
    List<dynamic> localAbsent =
        await fetchAttendanceAbsents(selectedEmployee['userId']);
    setState(() {
      absents = localAbsent;
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

  void searchEmployeeIndividual(String query) {
    setState(() {
      if (query.isNotEmpty) {
        // Filter allEmployees based on the query
        // Assuming 'name' is the key you want to search for
        allEmployees = allEmployees.where((employee) =>
            employee['name'].toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        // If query is empty, show all employees
        // You may fetch the original list from your data source again here
        // For example:
        // allEmployees = getAllEmployees(); // You need to implement this method
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
    return !isIndividualEmployeeSelected
        ? Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              scrollDirection: Axis.vertical,
              physics: inFocus == 0
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
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
                                    color: inFocus == 0
                                        ? Colors.white
                                        : Colors.black,
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
                                    color: inFocus == 1
                                        ? Colors.white
                                        : Colors.black,
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
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
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
                                            headingRowColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color>(
                                                        (Set<MaterialState>
                                                            states) {
                                              return Theme.of(context)
                                                  .colorScheme
                                                  .primary;
                                            }),
                                            headingTextStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            columns: const [
                                              DataColumn(
                                                  label: Text('Picture')),
                                              DataColumn(
                                                  label: Text('Employee ID')),
                                              DataColumn(label: Text('Name')),
                                              DataColumn(label: Text('Status')),
                                              DataColumn(
                                                  label: Text('Check-In Time')),
                                              DataColumn(
                                                  label:
                                                      Text('Check-Out Time')),
                                              DataColumn(label: Text('Action')),
                                            ],
                                            rows:
                                                (searchController2.text.isEmpty
                                                        ? employees
                                                        : searchList)
                                                    .asMap()
                                                    .entries
                                                    .map<DataRow>((entry) {
                                              int rowIndex =
                                                  searchController2.text.isEmpty
                                                      ? employees
                                                          .indexOf(entry.value)
                                                      : entry.key;
                                              dynamic employee = entry.value;
                                              bool isExpanded = expandedRows
                                                  .contains(rowIndex);
                                              return DataRow(cells: [
                                                DataCell(
                                                  SizedBox(
                                                    height: 60,
                                                    width: 60,
                                                    child: CachedNetworkImage(
                                                      imageUrl: getImageLink(
                                                          employee[
                                                              'profile_pic']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                    Text(employee['userId'])),
                                                DataCell(
                                                    Text(employee['name'])),
                                                DataCell(Text(
                                                    getAttendanceStatus(
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              // print(
                                                              //     "Attendacne: ${getAttendanceStatus(employee['userId'])}");
                                                              toggleActionExpansion(
                                                                  rowIndex);
                                                            },
                                                            style:
                                                                ElevatedButton
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
                                                                            employee['userId'])
                                                                        ? null
                                                                        : () async {
                                                                            bool result = await TakeAttendance.checkIn(
                                                                                employee['userId'],
                                                                                '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                                                                                '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                                                                'Present');
                                                                            //
                                                                            // print(
                                                                            //     'Attendance: $result');

                                                                            if (result) {
                                                                              showCustomSuccessDialog('Check-In Successful!', context);
                                                                            } else {
                                                                              showCustomSuccessDialog('Check-In Failed!', context);
                                                                            }
                                                                          },
                                                                    style: ElevatedButton
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
                                                                  child: ElevatedButton(
                                                                      onPressed: isCheckedOut(employee['userId']) || getAttendanceStatus(employee['userId']) == 'Absent' || !isCheckedIn(employee['userId'])
                                                                          ? null
                                                                          : () async {
                                                                              //send check-out request to the server

                                                                              bool result = await TakeAttendance.checkout(employee['userId'], '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}', '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                                                                              if (result) {
                                                                                showCustomSuccessDialog('Check-Out Successful!', context);
                                                                              } else {
                                                                                showCustomSuccessDialog('Check-Out Failed!', context);
                                                                              }
                                                                            },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blueAccent,
                                                                        foregroundColor:
                                                                            Colors.white,
                                                                      ),
                                                                      child: const Text('Check-Out')),
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                SizedBox(
                                                                  width: 130,
                                                                  child: ElevatedButton(
                                                                      onPressed: getAttendanceStatus(employee['userId']) == 'Present' || getAttendanceStatus(employee['userId']) == 'Absent'
                                                                          ? null
                                                                          : () async {
                                                                              //send absent request to the server
                                                                              bool result = await AbsentAttendance.set(employee['userId'], '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');
                                                                              if (result) {
                                                                                showCustomSuccessDialog("${employee['name']} marked as absent!!", context);
                                                                              } else {
                                                                                showCustomSuccessDialog('Failed to mark as absent!', context);
                                                                              }
                                                                            },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        foregroundColor:
                                                                            Colors.white,
                                                                      ),
                                                                      child: const Text('Absent')),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        controller: searchController3,
                                        onChanged: (value) {
                                          searchEmployeeIndividual(value);
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
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  height: 600,
                                  child: allEmployees.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : ListView.builder(
                                          itemCount: allEmployees.length,
                                          itemBuilder: (context, index) {
                                            dynamic employee =
                                                allEmployees[index];
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            getImageLink(employee[
                                                                'profile_pic'])),
                                                  ),
                                                  title: Text(employee['name']),
                                                  subtitle:
                                                      Text(employee['userId']),
                                                  trailing: Text(
                                                      getAttendanceStatus(
                                                          employee['userId'])),
                                                  onTap: () {
                                                    setState(() {
                                                      individualEmployee =
                                                          employee;
                                                      isIndividualEmployeeSelected =
                                                          true;
                                                    });
                                                  },
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Colors.grey[300],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                )
                              ],
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 100,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance Stats of',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    individualEmployee['name'],
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isIndividualEmployeeSelected = false;
                    });

                    setState(() {
                      selectedDateData.clear();
                      selectedDate = '';
                      data.clear();
                    });
                  },
                  icon: Icon(Icons.close),
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          underline: const SizedBox.shrink(),
                          dropdownColor: Colors.grey.shade300,
                          hint: Text(selectedDate.isNotEmpty
                              ? selectedDate
                              : 'Select Month-Year'),
                          items: _buildDropdownMenuItems(),
                          onChanged: (value) {
                            setState(() {
                              selectedDate = value.toString();
                            });

                            selectedDateData = attendanceStatsIndividual.firstWhere((element) => element['month'] == value);

                            List<String> absentDates = selectedDateData['absent_dates'].split(', ');

                            data.clear();

                            setState(() {
                              data=generateDataSource(absentDates,selectedDateData);
                            });

                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      selectedDate.isNotEmpty
                          ? Expanded(
                              child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Stats for:',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${getDetailedDate(selectedDate)}',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ))
                          : const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(height: 20),
                  selectedDate.isEmpty
                      ? Container(
                          height: 720,
                          child: Center(
                            child: _buildDropdownMenuItems().length==0?Text('Not enough data to show!' ,style: TextStyle(color: Colors.grey[600]),):  Text(
                              'Please select a month-year to view attendance stats',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        )
                      : Column(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        // color: Colors.red,
                        child: Row(
                          children:[
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Average Check-In Time', style: TextStyle(color: Colors.grey)),
                                  Expanded(child: Center(child: Text(formatTimeToAMPM(selectedDateData['avg_checkin_time']),style: GoogleFonts.inter(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),)))
                                ],
                              ),
                            )),
                            const SizedBox(width: 20),
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Average Check-Out Time', style: TextStyle(color: Colors.grey)),
                                  Expanded(child: Center(child: Text(formatTimeToAMPM(selectedDateData['avg_checkout_time']),style: GoogleFonts.inter(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),)))
                                ],
                              ),
                            )),
                            const SizedBox(width: 20),
                            Expanded(child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Average Working Per Day', style: TextStyle(color: Colors.grey)),
                                  Expanded(child: Center(child: Text(formatTimeDuration(selectedDateData['avg_working_hours']),style: GoogleFonts.inter(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),)))
                                ],
                              ),
                            )),
                          ]
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Attendance Overview',style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),
                        const SizedBox(height: 20),

                        SfCartesianChart(
                          // tooltipBehavior: TooltipBehavior(enable: true),
                          // Use category axis for days
                          primaryXAxis: CategoryAxis(),
                          // Use numeric axis for presence/absence
                          primaryYAxis: NumericAxis(),
                          series: [
                            // Render the bar chart
                            ColumnSeries<AttendanceData, String>(

                              color: Colors.green,
                              dataSource: data,
                              xValueMapper: (AttendanceData attendance, _) =>
                              attendance.date.day.toString(),
                              yValueMapper: (AttendanceData attendance, _) =>
                              attendance.status == "Present" ? 1 : 0,
                              // Customize the data labels
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                // Show custom text for present and absent days
                                builder: (dynamic data, dynamic point,dynamic series,
                                    int pointIndex, int seriesIndex) {
                                  final color = data.status == "Present" ? Colors.black : Colors.red;
                                  return Text(data.status == "Present" ? 'P' : 'A',style: GoogleFonts.inter(color: color,fontWeight: FontWeight.bold));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )



                ],
              ),
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

    String now=DateFormat('yyyy-MM').format(DateTime.now());

    for (var attendance in attendanceStatsIndividual) {
      if(attendance['month']!=now){
        years.add(attendance['month']);
      }
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

  String getEventLoader(DateTime day) {
    String fYear = day.year.toString();
    String fMonth = day.month.toString();
    String fDay = day.day.toString();

    if (fMonth.length == 1) {
      fMonth = '0$fMonth';
    }

    if (fDay.length == 1) {
      fDay = '0$fDay';
    }

    String formattedEventLoader = '$fYear-$fMonth-$fDay';

    return formattedEventLoader;
  }

  bool isAbsent(String date) {
    print('Given Date: $date');
    print("Result: ${absents.contains(date)}  ");
    if (absents.contains(date)) {
      return true;
    } else {
      return false;
    }
  }

  List<dynamic> allEmployees = [];

  void fetchAllEmployees() async {
    List<dynamic> result = await FetchEmployee.fetchEmployee(null, null);
    setState(() {
      allEmployees = result;
    });
  }

  bool isIndividualEmployeeSelected = false;
  bool isDateSelected = false;

  String getDetailedDate(String date) {
    List parts = date.split('-');
    String year = parts[0];
    String month = parts[1];
    String day = '';

    if (month == '01') {
      day = 'January';
    } else if (month == '02') {
      day = 'February';
    } else if (month == '03') {
      day = 'March';
    } else if (month == '04') {
      day = 'April';
    } else if (month == '05') {
      day = 'May';
    } else if (month == '06') {
      day = 'June';
    } else if (month == '07') {
      day = 'July';
    } else if (month == '08') {
      day = 'August';
    } else if (month == '09') {
      day = 'September';
    } else if (month == '10') {
      day = 'October';
    } else if (month == '11') {
      day = 'November';
    } else if (month == '12') {
      day = 'December';
    }

    return '$day - $year';
  }

  Map<String,dynamic> selectedDateData = {};

  String formatTimeToAMPM(String timeString) {

    if(timeString==null){
      return '-';
    }
    // Parse the time string
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Determine AM or PM
    String period = (hour < 12) ? 'AM' : 'PM';

    // Convert hour to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    // Format hour and minute with leading zeros if necessary
    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');

    // Return the formatted time string
    return '$formattedHour:$formattedMinute $period';
  }

  String formatTimeDuration(String durationString) {

    if(durationString==null){
      return '-';
    }
    // Parse the time duration string
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2].split('.')[0]); // Remove milliseconds

    // Calculate total minutes
    int totalMinutes = hours * 60 + minutes;

    // Format the time duration
    String formattedDuration = '';
    if (totalMinutes >= 60) {
      int formattedHours = totalMinutes ~/ 60;
      int formattedMinutes = totalMinutes % 60;
      formattedDuration = '$formattedHours hours';
      if (formattedMinutes > 0) {
        formattedDuration += ' $formattedMinutes minutes';
      }
    } else {
      formattedDuration = '$totalMinutes minutes';
    }

    return formattedDuration;
  }
  List<AttendanceData> data = [
    // AttendanceData(DateTime(2024, 5, 1), "Present"),
    // AttendanceData(DateTime(2024, 5, 2), "Present"),
    // AttendanceData(DateTime(2024, 5, 3), "Absent"),
    // Add more data here for the whole month
  ];


  List<AttendanceData> generateDataSource(List<String> absentDates, dynamic selectedDateData) {

    absentDates ??= [];

    final List<AttendanceData> dataSource = [];
    // Get year and month from selectedDateData
    final String yearMonth = selectedDateData['month'];
    final int nowYear = int.parse(yearMonth.split('-')[0]);
    final int nowMonth = int.parse(yearMonth.split('-')[1]);

    final List<DateTime> allDates = List<DateTime>.generate(
      DateTime(nowYear, nowMonth + 1, 0).day,
          (int index) => DateTime(nowYear, nowMonth, index + 1),
    );

    for (DateTime date in allDates) {
      final String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (absentDates.contains(formattedDate)) {
        dataSource.add(AttendanceData(date, "Absent"));
      } else {
        dataSource.add(AttendanceData(date, "Present"));
      }
      // Break loop if the date is today
      if (date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day) {
        break;
      }
    }
    return dataSource;
  }

  TextEditingController searchController3 = TextEditingController();

}
class AttendanceData {
  final DateTime date;
  final String status;

  AttendanceData(this.date, this.status);
}