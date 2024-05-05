import 'dart:async';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmbrew/data/_fetch_announcements.dart';
import 'package:pharmbrew/data/_fetch_orders.dart';
import 'package:pharmbrew/data/_fetch_top_selling_product.dart';
import 'package:pharmbrew/data/_openweathermap.dart';
import 'package:pharmbrew/domain/_get_location.dart';
import 'package:pharmbrew/widgets/_dashboard_home_grid_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/_fetch_daily_analytics_attendance.dart';
import '../../../data/_fetch_top_customers.dart';
import '../../../data/_monthly_sales_analytics.dart';
import '../../../data/_sales_in_last_24h.dart';
import '../../../data/fetch_notification.dart';
import '../../../domain/_fetch_products.dart';
import '../../../utils/_show_dialog.dart';
import '../../../utils/_show_dialog2.dart';

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
  late Timer timer2;

  void _fetchNotification() async {
    notifications = await FetchNotification.fetch();
    // print(notifications);
    setState(() {
      notificationsCount = 0;
    });
    //read the status of notifications:
    for (var notification in notifications) {
      if (notification['status'] == 'unread' &&
          notification['receiver'] == 'hr' &&
          notification['receiver_id'] == null) {
        setState(() {
          notificationsCount++;
        });
      }
    }
    print("Notifications: $notificationsCount");
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

    timer2 = Timer.periodic(
        const Duration(milliseconds: 500), (Timer t) => getOrderDetails());

    getMonthlySales();

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getTopSellingProducts();
    });
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getTopSellingProducts();
    });
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getTopCustomers();
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getSalesInLast24h();
    });

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      fetchAnnouncements();
    });
  }

  late String pp = ''; // Initialize pp with an empty string
  late String name = '';
  late String userId = '';

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      pp = prefs.getString('loggedInUserProfilePic') ??
          ''; // Assign x to pp, if x is null assign an empty string

      name = prefs.getString('loggedInUserName') ?? '';
      userId = prefs.getString('loggedInUserId') ??
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
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }

  bool isTextFieldFocused = false;

  void _onFocusChange() {
    setState(() {
      isTextFieldFocused = focusNode.hasFocus;
    });
  }

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
                  controller: searchController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Search anything from google",
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
                        ? MouseRegion(
                            onEnter: (event) {
                              setState(() {
                                isHoveringSearchButton = true;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                isHoveringSearchButton = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: isHoveringSearchButton
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black,
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

              // AnimatedContainer(
              //   duration: Duration(milliseconds: 300),
              //   curve: Curves.easeInOut,
              //   child: Row(
              //     children: [
              //       Text('Welcome back!',style: GoogleFonts.inter(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),)
              //     ],
              //   ),
              // ),

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
                                  offset: const Offset(10, -10),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
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
                                                data: getTotalEmployees()
                                                    .toString(),
                                                image: dashboardItems[index]
                                                    ["image"],
                                              )
                                            : index == 3
                                                ? DashboardGridItem(
                                                    background: Colors.white,
                                                    textColor: Colors.black,
                                                    title: dashboardItems[index]
                                                        ["title"],
                                                    data: attendanceStats[
                                                        'present_today'],
                                                    image: dashboardItems[index]
                                                        ["image"],
                                                  )
                                                : DashboardGridItem(
                                                    background: Colors.white,
                                                    textColor: Colors.black,
                                                    title: dashboardItems[index]
                                                        ["title"],
                                                    data:
                                                        "BDT ${earnings.toString()}",
                                                    image: dashboardItems[index]
                                                        ["image"],
                                                    isCost: true,
                                                    salesInLast24Hours:
                                                        '${salesInLast24h['totalSales'] ?? 0}',
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
                                          tooltipBehavior: TooltipBehavior(
                                            enable: true,
                                            canShowMarker: true,
                                            // header: '',
                                            // format: 'point.x : point.y',
                                          ),
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
                                                    double.parse(
                                                        attendanceStats[
                                                            'present_today'])),
                                                PieChartData(
                                                    'Absent',
                                                    double.parse(
                                                        attendanceStats[
                                                            'absent_today'])),
                                                PieChartData(
                                                    "Didn't CheckedIn",
                                                    double.parse(
                                                        attendanceStats[
                                                            'not_checked_in'])),
                                              ],
                                              xValueMapper:
                                                  (PieChartData data, _) =>
                                                      data.category,
                                              yValueMapper:
                                                  (PieChartData data, _) =>
                                                      data.value,
                                              dataLabelMapper: (PieChartData
                                                          data,
                                                      _) =>
                                                  '${data.category}: ${data.value}',
                                              explode: true,
                                              explodeIndex: getMaxedIndex(),
                                              explodeOffset: '10%',

                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                isVisible: true,
                                                textStyle: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside,
                                                labelIntersectAction:
                                                    LabelIntersectAction.shift,
                                                connectorLineSettings:
                                                    const ConnectorLineSettings(
                                                  type: ConnectorType.line,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 600,
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
                            margin: const EdgeInsets.only(left: 20),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Top Selling Products',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 50,
                                ),
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          // border: Border.all(color: Colors.grey.shade200,width: 3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Product Name',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 30),
                                              width: 100,
                                              child: Text(
                                                'Quantity',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              width: 220,
                                              margin: const EdgeInsets.only(
                                                  right: 30),
                                              child: Text(
                                                'Customer Name',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              margin: const EdgeInsets.only(
                                                  bottom: 15,
                                                  left: 10,
                                                  right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors
                                                              .grey.shade200,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child:
                                                            LottieBuilder.asset(
                                                          'assets/animations/capsule_med.json',
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        child: Text(
                                                          topSellingProducts[
                                                                  index]
                                                              ['productName'],
                                                          style: GoogleFonts
                                                              .inter(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    child: Text(
                                                      topSellingProducts[index]
                                                          ['quantity'],
                                                      style:
                                                          GoogleFonts.inter(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .shade100,
                                                            backgroundImage:
                                                                AssetImage(
                                                              'assets/images/user.png',
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Container(
                                                          width: 140,
                                                          child: Text(
                                                            topSellingProducts[
                                                                    index][
                                                                'customerName'],
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: GoogleFonts
                                                                .inter(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 600,
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
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Our Beloved Customers',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  height: 50,
                                ),
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          // border: Border.all(color: Colors.grey.shade200,width: 3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Customer Name',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 30),
                                              width: 100,
                                              child: Text(
                                                'Total Orders',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                                child: Container(
                                              alignment: Alignment.center,
                                              width: 220,
                                              margin: const EdgeInsets.only(
                                                  right: 30),
                                              child: Text(
                                                'Total Spent',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.shade200,
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              margin: const EdgeInsets.only(
                                                  bottom: 15,
                                                  left: 10,
                                                  right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade100,
                                                          backgroundImage:
                                                              AssetImage(
                                                            'assets/images/user.png',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        child: Text(
                                                          topCustomers[index]
                                                              ['customerName'],
                                                          style: GoogleFonts
                                                              .inter(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    child: Text(
                                                      topCustomers[index]
                                                          ['totalOrders'],
                                                      style:
                                                          GoogleFonts.inter(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 140,
                                                          child: Text(
                                                            "BDT ${topCustomers[index]['totalBill']}",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: GoogleFonts
                                                                .inter(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
      "title": "Employees",
      "data": "120",
      "image": "assets/images/icons8-employees-100.png"
    },
    {
      "title": "Checked In Employees",
      "data": "118",
      "image": "assets/images/icons8-attendance-100.png"
    },
    {
      "title": "Sales Revenue",
      "data": "118",
      "image": "assets/images/icons8-attendance-100.png"
    }
  ];

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

  int getTotalEmployees() {
    int count = 0;
    count += int.parse(attendanceStats['present_today']);
    count += int.parse(attendanceStats['absent_today']);
    count += int.parse(attendanceStats['not_checked_in']);
    return count;
  }

  List<dynamic> orderDetails = [];
  late double earnings = 0.0;

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

  List<dynamic> topSellingProducts = [];

  void getTopSellingProducts() async {
    var data = await TopSellingProducts.fetch();

    setState(() {
      topSellingProducts = data;
    });
  }

  List<dynamic> topCustomers = [];

  void getTopCustomers() async {
    var data = await TopCustomers.fetch();
    setState(() {
      topCustomers = data;
    });
  }

  Map<String, dynamic> salesInLast24h = {};

  void getSalesInLast24h() async {
    var data = await SalesInLast24h.fetch();
    setState(() {
      salesInLast24h = data;
    });
  }

  final TextEditingController searchController = TextEditingController();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int isHovered = -1;

  bool isHoveringSearchButton = false;

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
}

class PieChartData {
  PieChartData(this.category, this.value);

  final String category;
  final double value;
}

class SalesData {
  final String day;
  final double amount;

  SalesData(this.day, this.amount);
}
