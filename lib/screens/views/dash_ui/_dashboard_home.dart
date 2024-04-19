import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_openweathermap.dart';
import 'package:pharmbrew/domain/_get_location.dart';
import 'package:pharmbrew/widgets/_dashboard_home_grid_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../data/_fetch_daily_analytics_attendance.dart';
import '../../../data/fetch_notification.dart';
import '../../../domain/_fetch_products.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final ScrollController _scrollController = ScrollController();
  final Duration _scrollDuration = const Duration(milliseconds: 500);
  FocusNode focusNode = FocusNode();

  late String? country = "";
  late String? region = "";
  late String? weather = "";

  late Timer timer;

  void _fetchNotification() async {
    notifications = await FetchNotification.fetch();
    // print(notifications);
    setState(() {
      notificationsCount = 0;
    });
    //read the status of notifications:
    for (var notification in notifications) {
      if (notification['status'] == 'unread') {
        setState(() {
          notificationsCount++;
        });
      }
    }
    print("Notifications: $notificationsCount");
  }

  int products=-1;

  void getProducts() async {
    List<dynamic> emp = await fetchProducts();
    setState(() {
      products = emp.length;
    });
  }

  dynamic attendanceStats = {};

  void fetchAttendanceStats() async {
    var attendance = await DailyAnalyticsAttendanceFetcher.fetch();
   setState(() {
      attendanceStats = attendance;
   });
  }

  List<dynamic> notifications = [];
  int notificationsCount = 0;

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

    timer = Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => _fetchNotification());

    Timer(const Duration(milliseconds: 500), () {
      fetchAttendanceStats();
    });

    Timer(const Duration(milliseconds: 500), () {
      getProducts();
    });
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
  }

  bool isTextFieldFocused = false;

  void _onFocusChange() {
    setState(() {
      isTextFieldFocused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width - 200;
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
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .surface,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .surface,
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .background,
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
          child: attendanceStats.isEmpty || products==-1? Container(
            child: const Center(
              child: CircularProgressIndicator(),
            )
          ) : ListView(
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
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return index==0? DashboardGridItem(
                            title: dashboardItems[index]["title"],
                            data: products.toString(),
                            image: dashboardItems[index]["image"],
                          ): index==1? DashboardGridItem(
                            title: dashboardItems[index]["title"],
                            data: dashboardItems[index]["data"],
                            image: dashboardItems[index]["image"],
                          ): index==2? DashboardGridItem(
                            title: dashboardItems[index]["title"],
                            data: getTotalEmployees().toString(),
                            image: dashboardItems[index]["image"],
                          ): DashboardGridItem(
                            title: dashboardItems[index]["title"],
                            data: attendanceStats['present_today'],
                            image: dashboardItems[index]["image"],
                          );
                        },
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 400,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
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
                        )),

                    const SizedBox(
                      width: 10,
                    ),

                    //attendance pie chart
                    Expanded(
                        child: Container(
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
                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Attendance Chart',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              attendanceStats.isNotEmpty
                                  ? // Modify the SfCircularChart widget
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: SfCircularChart(
                                  legend: const Legend(
                                      position: LegendPosition.bottom,
                                      isVisible: true,
                                      overflowMode:
                                      LegendItemOverflowMode.wrap),
                                  series: <CircularSeries>[
                                    PieSeries<PieChartData, String>(
                                      animationDuration: 0,
                                      // animationDelay: 0,
                                      dataSource: <PieChartData>[
                                        PieChartData(
                                            'Present',
                                            double.parse(attendanceStats[
                                            'present_today'])),
                                        PieChartData(
                                            'Absent',
                                            double.parse(attendanceStats[
                                            'absent_today'])),
                                        PieChartData(
                                            "Didn't CheckedIn",
                                            double.parse(attendanceStats[
                                            'not_checked_in'])),
                                      ],
                                      xValueMapper: (PieChartData data, _) =>
                                      data.category,
                                      yValueMapper: (PieChartData data, _) =>
                                      data.value,
                                      dataLabelMapper: (PieChartData data, _) =>
                                      '${data.category}: ${data.value}',
                                      explode: true,
                                      explodeIndex: getMaxedIndex(),
                                      explodeOffset: '10%',

                                      dataLabelSettings:  DataLabelSettings(
                                        isVisible: true,
                                        textStyle: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        labelPosition: ChartDataLabelPosition.outside,
                                        labelIntersectAction: LabelIntersectAction.shift,
                                        connectorLineSettings: ConnectorLineSettings(
                                          type: ConnectorType.curve,
                                          length: '20%',
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const CircularProgressIndicator(),

                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<dynamic> dashboardItems = [
    {
      "title": "Products in inventory",
      "data": "130",
      "image": "assets/images/icons8-pills-100.png"
    },
    {
      "title": "Orders Pending",
      "data": "34",
      "image": "assets/images/icons8-order-100.png"
    },
    {
      "title": "Employees",
      "data": "120",
      "image": "assets/images/icons8-employees-100.png"
    },
    {
      "title": "Present Employees",
      "data": "118",
      "image": "assets/images/icons8-attendance-100.png"
    }
  ];


  int getMaxedIndex(){
    int maxIndex = 0;
    double max = 0;
    for(int i = 0; i < 3; i++){
      if(double.parse(attendanceStats.values.elementAt(i)) > max){
        max = double.parse(attendanceStats.values.elementAt(i));
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  int getTotalEmployees(){
    int count=0;
    count+=int.parse(attendanceStats['present_today']);
    count+=int.parse(attendanceStats['absent_today']);
    count+=int.parse(attendanceStats['not_checked_in']);
    return count;
  }
}




class PieChartData {
  PieChartData(this.category, this.value);

  final String category;
  final double value;
}
