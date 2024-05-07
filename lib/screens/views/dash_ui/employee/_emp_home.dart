import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/_fetch_all_attendance.dart';
import '../../../../data/_fetch_announcements.dart';
import '../../../../data/_fetch_current_month_attendance.dart';
import '../../../../data/_fetch_daily_analytics_attendance.dart';
import '../../../../data/_fetch_orders.dart';
import '../../../../data/_monthly_sales_analytics.dart';
import '../../../../data/_openweathermap.dart';
import '../../../../data/_sales_in_last_24h.dart';
import '../../../../data/fetch_notification.dart';
import '../../../../domain/_fetch_products.dart';
import '../../../../domain/_get_location.dart';
import '../../../../widgets/_dashboard_home_grid_item.dart';
import '../_dashboard_home.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<EmployeeHome> {
  final ScrollController _scrollController = ScrollController();
  final Duration _scrollDuration = const Duration(milliseconds: 500);
  FocusNode focusNode = FocusNode();

  late String? country = "";
  late String? region = "";
  late String? weather = "";

  late Timer timer, timer2;
  late List<SalesData> _salesData = [];

  void getMonthlySales() async {
    var data = await MonthlySales.fetch();
    // print(data);

    List<SalesData> salesData = [];

    for (var day in data) {
      setState(() {
        _salesData.add(SalesData(day['day'], double.parse(day['sales'])));
      });
    }

    print("sales: $_salesData");
  }

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

    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) => _fetchNotification());
    Timer(const Duration(milliseconds: 500), () {
      fetchAttendanceStats();
    });

    Timer(const Duration(milliseconds: 500), () {
      getProducts();
    });

    timer2 = Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => getOrderDetails());

    getMonthlySales();



    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getSalesInLast24h();
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      fetchAnnouncements();
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      initAttendanceData();
    });

    fetchAttendanceDataCurrentMonth();

  }

  void getSalesInLast24h() async {
    var data = await SalesInLast24h.fetch();
    setState(() {
      salesInLast24h = data;
    });
  }

  void getOrderDetails() async {
    var data = await FetchOrders.fetch();
    double earningLocal = 0.0;
    setState(() {
      orderDetails = data;
    });

    for (var order in orderDetails) {
      earningLocal += double.parse(order['totalCost']);
    }

    setState(() {
      earnings = earningLocal;
    });
  }

  void _fetchNotification() async {
    var notifications = await FetchNotification.fetch();
    // print(notifications);
    setState(() {
      notificationsCount = 0;
    });

    print('Logged in user: $userId');
    //read the status of notifications:
    for (var notification in notifications) {
      if (notification['status'] == 'unread' &&
          notification['receiver'] == 'employee' &&
          notification['receiver_id'] == userId) {
        setState(() {
          notificationsCount++;
        });
      }
    }
    print("Notifications: $notificationsCount");
  }

  late String pp = ''; // Initialize pp with an empty string
  late String name = '';
  late String userId='';
  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      pp = prefs.getString('loggedInUserProfilePic') ??
          ''; // Assign x to pp, if x is null assign an empty string

      name = prefs.getString('loggedInUserName') ??
          ''; // Assign x to pp, if x is null assign an empty string
      userId = prefs.getString('loggedInUserId') ??
          '';
    });

    country = await getCountry();
    region = await getRegion();
    weather = await getWeather();

    setState(() {
      country = country;
      region = region;
      weather = "${weather?.split(".")[0]}°C";
    });
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    _scrollController.dispose(); // Dispose ScrollController
    focusNode.dispose(); // Dispose FocusNode
    super.dispose();
    timer.cancel();
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
    return announcements.isEmpty || attendanceDataCurrentMonth.isEmpty || _salesData.isEmpty ?Center(
      child: CircularProgressIndicator(),
    ) : Column(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    weather!.isNotEmpty
                        ? Text(
                      weather!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 3,
                    ),
                    country!.isEmpty || region!.isEmpty
                        ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator())
                        : Text(
                      "$region, $country",
                      style: const TextStyle(
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
                  controller: searchController,
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
                        onPressed: () {
                          var text = searchController.text.trim();
                          if (text.isNotEmpty) {
                            _launchURL(
                                'https://www.google.com/search?q=$text');
                            searchController.clear();
                          }
                        },
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
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear,
                      child: Stack(
                        children: [
                          Icon(
                            CupertinoIcons.bell_fill,
                            color: Colors.grey.shade700,
                          ),
                          notificationsCount > 0
                              ? Transform.translate(
                            offset: Offset(10, -10),
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  notificationsCount.toString(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ],
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
          child: attendanceStats.isEmpty || products == -1
              ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ))
              : ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? DashboardGridItem(
                            background: Colors.white,
                            textColor: Colors.black,
                            title: dashboardItems[index]["title"],
                            data: products.toString(),
                            image: dashboardItems[index]["image"],
                          )
                              : index == 1
                              ? DashboardGridItem(
                            background: Colors.white,
                            textColor: Colors.black,
                            title: dashboardItems[index]
                            ["title"],
                            data:
                            orderDetails.length.toString(),
                            image: dashboardItems[index]
                            ["image"],
                          )
                              : index == 2
                              ? DashboardGridItem(
                            background: Colors.white,
                            textColor: Colors.black,
                            title: dashboardItems[index]
                            ["title"],
                            data: getCheckinTime(),
                            image: dashboardItems[index]
                            ["image"],
                            isCost: true,
                          )
                              : index == 3
                              ? DashboardGridItem(
                            background: Colors.white,
                            textColor: Colors.black,
                            title: dashboardItems[index]
                            ["title"],
                            data: getCheckoutTime(),
                            image: dashboardItems[index]
                            ["image"],
                            isCost: true,
                          )
                              : DashboardGridItem(
                            background: Colors.white,
                            textColor: Colors.black,
                            title: dashboardItems[index]
                            ["title"],
                            data:
                            "BDT ${salesInLast24h['totalSales'] ?? 0}",
                            image: dashboardItems[index]
                            ["image"],
                            isCost: true,
                          );
                        },
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 400,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text('Sales In Current Month (BDT)',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: SfCartesianChart(
                                    enableAxisAnimation: true,
                                    primaryXAxis: const CategoryAxis(),
                                    series: [
                                      LineSeries<SalesData, String>(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        dataSource: _salesData,
                                        xValueMapper: (SalesData sales, _) =>
                                        sales.day,
                                        yValueMapper: (SalesData sales, _) =>
                                        sales.amount,
                                        // dataLabelSettings: const DataLabelSettings(
                                        //   isVisible: true,
                                        // ),
                                        width: 5,

                                        enableTooltip: true,
                                        markerSettings: MarkerSettings(
                                          isVisible: true,
                                          color: Colors.black,
                                          shape: DataMarkerType.circle,
                                        ),
                                      ),
                                    ],
                                    tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      canShowMarker: true,
                                      // header: '',
                                      // format: 'point.x : point.y',
                                    )),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Attendance Overview',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                  builder: (dynamic data,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    final color = data.status == "Present"
                                        ? Colors.black
                                        :data.status == "Absent"
                                        ? Colors.red
                                        : Colors.grey;
                                    return Text(
                                        data.status == "Present"
                                            ? 'P'
                                            : data.status == 'Absent'
                                            ? 'A'
                                            : '-',
                                        style: GoogleFonts.inter(
                                            color: color,
                                            fontWeight: FontWeight.bold));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 570,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 20,bottom: 10,left: 10,right: 10),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Latest Announcements',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    Expanded(child:
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              isHovered = index;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isHovered = -1;
                            });
                          },
                          child: AnimatedContainer(
                            curve: Curves.easeIn,
                            duration:
                            Duration(milliseconds: 250),
                            color: isHovered == index
                                ? Colors.grey.shade300
                                : Colors.white,
                            height: 150,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10,horizontal: 10),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          Text(
                                            getFormattedDate(
                                                announcements[
                                                index][
                                                'start_date']),
                                            style: GoogleFonts.inter(
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          const SizedBox(
                                              height: 5),
                                          Text(
                                            getYear(announcements[
                                            index]
                                            ['start_date']),
                                            style: GoogleFonts.inter(
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                AnimatedContainer(
                                  curve: Curves.easeIn,
                                  duration: Duration(
                                      milliseconds: 250),
                                  width: isHovered == index
                                      ? 5
                                      : 2,
                                  color: isHovered == index
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade300,
                                  height: null,
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              announcements[index]
                                              ['title'],
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  10,
                                                  vertical:
                                                  5),
                                              decoration:
                                              BoxDecoration(
                                                color: checkStatus(
                                                    announcements[index][
                                                    'start_date'],
                                                    announcements[index][
                                                    'end_date']) ==
                                                    'Ongoing'
                                                    ? Colors
                                                    .green
                                                    : checkStatus(announcements[index]['start_date'], announcements[index]['end_date']) ==
                                                    'Upcoming'
                                                    ? Colors
                                                    .blue
                                                    : Colors
                                                    .red,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              child: Text(
                                                checkStatus(
                                                    announcements[
                                                    index]
                                                    [
                                                    'start_date'],
                                                    announcements[
                                                    index]
                                                    [
                                                    'end_date']),
                                                style: TextStyle(
                                                    color: Colors
                                                        .white),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                            height: 10),
                                        Text(
                                          formatSingleLine(
                                              announcements[index][
                                              'description']),
                                          textAlign:
                                          TextAlign.justify,
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          style: TextStyle(
                                              color:
                                              Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        )
      ],
    );
  }

  int isHovered = -1;

  int notificationsCount=0;

  final TextEditingController searchController = TextEditingController();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<dynamic> announcements= [];

  void fetchAnnouncements() async {
    List<dynamic> localAnnouncements = await FetchAnnouncements.fetch();
    setState(() {
      announcements = localAnnouncements;
    });
  }
  String formatSingleLine(String text) {
    return text.replaceAll(RegExp(r'[\n\r\f\v]'), ' ');
  }

  String getFormattedDate(String date) {
    List<String> dateParts = date.split('-');

    // Convert the date parts to integers
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // Create a DateTime object
    DateTime dateTime = DateTime(year, month, day);

    // Format the DateTime object
    String formattedDate = DateFormat('MMMM d').format(dateTime);
    return formattedDate;
  }

  String checkStatus(String startingDate, String endingDate) {
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(startingDate);
    DateTime end = DateTime.parse(endingDate);

    if ((now.isAfter(start) && now.isBefore(end)) || (startingDate==endingDate && startingDate==now.toString().split(' ')[0])) {
      return 'Ongoing';
    } else if (now.isBefore(start)) {
      return 'Upcoming';
    } else {
      return 'Ended';
    }
  }

  String getYear(String date) {
    List<String> dateParts = date.split('-');

    return dateParts[0];
  }

  int products = -1;

  void getProducts() async {
    List<dynamic> emp = await fetchProducts();
    setState(() {
      products = emp.length;
    });
  }

  dynamic attendanceStats = {};

  void fetchAttendanceStats() async {
    String date = DateTime.now().toString().split(' ')[0];
    var attendance = await DailyAnalyticsAttendanceFetcher.fetch(date);
    setState(() {
      attendanceStats = attendance;
    });
  }

  int getMaxedIndex() {
    int maxIndex = 0;
    double max = 0;
    for (int i = 0; i < 3; i++) {
      if (double.parse(attendanceStats.values.elementAt(i)) > max) {
        max = double.parse(attendanceStats.values.elementAt(i));
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  List<dynamic> orderDetails = [];

  List<dynamic> dashboardItems = [
    {
      "title": "Products in inventory",
      "data": "130",
      "image": "assets/images/icons8-pills-100.png"
    },
    {
      "title": "Orders Placed",
      "data": "34",
      "image": "assets/images/icons8-order-100.png"
    },
    {
      "title": "Check-In Time",
      "data": "120",
      "image": "assets/images/icons8-employees-100.png"
    },
    {
      "title": "Check-Out Time",
      "data": "118",
      "image": "assets/images/icons8-attendance-100.png"
    },
    {
      "title": "Sales In Last 24h",
      "data": "118",
      "image": "assets/images/icons8-attendance-100.png"
    }
  ];
  int getTotalEmployees() {
    int count = 0;
    count += int.parse(attendanceStats['present_today']);
    count += int.parse(attendanceStats['absent_today']);
    count += int.parse(attendanceStats['not_checked_in']);
    return count;
  }
  Map<String, dynamic> salesInLast24h = {};
  late double earnings = 0.0;


  List<dynamic> allAttendanceData=[];

  void initAttendanceData()async{
    var data=await FetchAllAttendance.fetch();
    setState(() {
      allAttendanceData=data;
    });
  }

  String getCheckinTime(){
    for(var attendance in allAttendanceData){
      if(attendance['userId']==userId){
        return attendance['checkInTime']==null?'Absent': convertTo12HourFormat(attendance['checkInTime']);
      }
    }

    return 'Yet to check in';
  }

  String getCheckoutTime(){
    for(var attendance in allAttendanceData){
      if(attendance['userId']==userId){
        return attendance['checkOutTime']==null && attendance['checkInTime']==null? 'Absent':attendance['checkOutTime']==null?'Yet to check out':convertTo12HourFormat(attendance['checkOutTime']);
      }
    }

    return 'Yet to check in';
  }


  String convertTo12HourFormat(String twentyFourHourTime) {
    final format24 = DateFormat.Hm();
    final dateTime24 = format24.parse(twentyFourHourTime);

    final format12 = DateFormat.jm();
    final twelveHourTime = format12.format(dateTime24);

    return twelveHourTime;
  }


  List<AttendanceData> data = [
    // AttendanceData(DateTime(2024, 5, 1), "Present"),
    // AttendanceData(DateTime(2024, 5, 2), "Present"),
    // AttendanceData(DateTime(2024, 5, 3), "Absent"),
    // Add more data here for the whole month
  ];


  List<AttendanceData> generateDataSource(){
    List<AttendanceData> data = [];
    for (var attendance in attendanceDataCurrentMonth) {
      data.add(AttendanceData(DateTime.parse(attendance['date']), attendance['status']));
    }
    return data;
  }

  List<dynamic> attendanceDataCurrentMonth=[];
  void fetchAttendanceDataCurrentMonth()async{
    Future.delayed(Duration(milliseconds: 1000), () async {
      var data=await FetchCurrentMonthAttendance.fetch(userId);
      data.sort((a,b)=>a['date'].compareTo(b['date']));
      setState(() {
        attendanceDataCurrentMonth=data;
      });

      print("Current Month: $attendanceDataCurrentMonth");
      setState(() {
        this.data=generateDataSource();
      });
      print("Data: $data");
    });

  }

}

class AttendanceData {
  final DateTime date;
  final String status;

  AttendanceData(this.date, this.status);
}