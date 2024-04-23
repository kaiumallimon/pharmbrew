import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pharmbrew/data/_delete_announcement.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/_create_announcement.dart';
import '../../../data/_fetch_announcements.dart';
import '../../../widgets/_detailed_announcement.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<Events> {
  late Timer timer1;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    timer1 = Timer.periodic(Duration(milliseconds: 500), (timer) {
      fetchAnnouncements();
    });

    initData();
  }

  late String userId='';

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('loggedInUserId') ??
          ''; // Assign x to pp, if x is null assign an empty string
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            color: Colors.white,
            child: Text(
              "Announcements",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            color: Colors.white,
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    inFocus = 0;
                  });
                },
                child: Container(
                  width: 200,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: inFocus == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'View Announcements',
                    style: TextStyle(
                      color: inFocus == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
                  width: 250,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: inFocus == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Create An Announcement',
                    style: TextStyle(
                      color: inFocus == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]),
          ),
          inFocus == 0
              ? Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              controller: searchController,
                              onChanged: (value) {
                                searchAnnouncements(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search Announcements',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.grey.shade500),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    searchList.isEmpty
                        ? Container(
                            height: 700,
                            width: double.infinity,
                            color: Colors.white,
                            child: isFetched && searchList.isEmpty
                                ? Center(
                                    child: Text("No Announcements Found"),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          )
                        : Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 200),
                            child: searchList.isEmpty
                                ? Container(
                                    height: 700,
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: searchList.length,
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
                                        child: GestureDetector(
                                          onTap: ()  {
                                            print('Announcement: ${searchList[index]}');
                                            showDetailedAnnouncement(
                                                context,
                                                searchList[index]['title'],
                                                searchList[index]
                                                    ['description'],
                                                searchList[index]['create_time']
                                                    .toString()
                                                    .split(' ')[0],
                                                searchList[index]['start_date']
                                                    .toString(),
                                                searchList[index]['end_date']
                                                    .toString(),
                                                searchList[index]
                                                        ['creator_name']
                                                    .toString(),
                                                searchList[index]
                                            );

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
                                                vertical: 10),
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
                                                              searchList[index]
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
                                                                            searchList[index][
                                                                                'start_date'],
                                                                            searchList[index][
                                                                                'end_date']) ==
                                                                        'Ongoing'
                                                                    ? Colors
                                                                        .green
                                                                    : checkStatus(searchList[index]['start_date'], searchList[index]['end_date']) ==
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
                                                                    searchList[
                                                                            index]
                                                                        [
                                                                        'start_date'],
                                                                    searchList[
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
                                                              searchList[index][
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
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    height: 150,
                                                    width: 60,
                                                    // color: Colors.red,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        bool result =
                                                            await DeleteAnnouncement
                                                                .delete(searchList[
                                                                        index][
                                                                    'announcementId']);

                                                        if (result) {
                                                          showCustomSuccessDialog(
                                                              "Announcement has been deleted successfully",
                                                              context);
                                                        } else {
                                                          showCustomErrorDialog(
                                                              "An error occurred while deleting the announcement",
                                                              context);
                                                        }
                                                      },
                                                      icon: Icon(Icons.delete),
                                                      color:
                                                          Colors.grey.shade500,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ],
                )
              : Container(
                  color: Colors.white,
                  height: 830,
                  padding: const EdgeInsets.symmetric(horizontal: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Announcement Title',
                         style: TextStyle(
                           color: Colors.grey.shade800
                         )),
                          const SizedBox(height: 10),
                         TextField(
                           controller: titleController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500
                              ),
                              hintText: 'eg. Victory Day Celebration',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300,width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.orange,width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade300,
                            ),

                         ),
                       ],
                     ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Announcement Description',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Expanded(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.top,
                                controller: descriptionController,
                                maxLines: null, // Allow the text field to expand vertically
                                expands: true, // Allow the text field to expand vertically
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                  hintText: 'Write the announcement description here...',
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
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: SizedBox(
                            height: 50,

                            child: ElevatedButton(onPressed: ()async{
                              DateTime? selectedDateLocal=await _selectDate(context, DateTime.now());
                              setState(() {
                                selectedDate=selectedDateLocal;
                              });
                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                                // side: BorderSide(color: Colors.grey.shade300,width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(selectedDate==null?'Select Event Starting Date':selectedDate.toString().split(' ')[0]),),
                          )),
                          const SizedBox(width: 20),
                          Expanded(child: SizedBox(
                            height: 50,

                            child: ElevatedButton(onPressed: ()async{
                              DateTime? selectedDateLocal=await _selectDate(context, DateTime.now());
                              setState(() {
                                selectedEndingDate=selectedDateLocal;
                              });
                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black,
                                // side: BorderSide(color: Colors.grey.shade300,width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(selectedEndingDate==null?'Select Event Ending Date':selectedEndingDate.toString().split(' ')[0]),),
                          ),)
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: SizedBox(
                            height: 50,

                            child: ElevatedButton(onPressed: ()async{
                              String title=titleController.text.toString().trim();
                              String description=descriptionController.text.toString().trim();
                              String startingDate=selectedDate.toString().split(' ')[0];
                              String endingDate=selectedEndingDate.toString().split(' ')[0];

                              if(title.isEmpty || description.isEmpty || startingDate.isEmpty || endingDate.isEmpty){
                                showCustomErrorDialog('Please fill all the fields', context);
                                return;
                              }else{
                                bool result=await CreateAnnouncement.create(title, description, DateTime.now().toString(), userId, startingDate, endingDate);
                                if(result){
                                  showCustomSuccessDialog('Announcement has been created successfully', context);
                                  titleController.clear();
                                  descriptionController.clear();
                                  selectedDate=null;
                                  selectedEndingDate=null;
                                }else{
                                  showCustomErrorDialog('An error occurred while creating the announcement', context);
                                }
                              }

                            },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                // side: BorderSide(color: Colors.grey.shade300,width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Save'),
                            ),))
                        ],
                      )

                    ],
                  ),
                )
        ],
      ),
    );
  }

  int inFocus = 0;
  TextEditingController searchController = TextEditingController();
  List<dynamic> announcements = [];

  void fetchAnnouncements() async {
    List<dynamic> localAnnouncements = await FetchAnnouncements.fetch();
    setState(() {
      announcements = localAnnouncements;
      searchAnnouncements(searchText);
    });

    if (!isFetched) {
      setState(() {
        isFetched = true;
      });
    }
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

  String getYear(String date) {
    List<String> dateParts = date.split('-');

    return dateParts[0];
  }

  List<dynamic> searchList = [];

  void searchAnnouncements(String query) {
    setState(() {
      searchText = query;
      searchList = announcements.where((element) {
        return element['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  String checkStatus(String startingDate, String endingDate) {
    DateTime now = DateTime.now();
    DateTime start = DateTime.parse(startingDate);
    DateTime end = DateTime.parse(endingDate);

    if (now.isAfter(start) && now.isBefore(end)) {
      return 'Ongoing';
    } else if (now.isBefore(start)) {
      return 'Upcoming';
    } else {
      return 'Ended';
    }
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime dateTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      lastDate: DateTime(DateTime.now().year + 10, 12),
    );
    return picked;
  }

  bool isFetched = false;
  int isHovered = -1;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime? selectedDate=null;
  late DateTime? selectedEndingDate=null;




}
