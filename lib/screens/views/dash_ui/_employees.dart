import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_fetch_employee.dart';

import '_search_employee.dart';

class EmployeesAll extends StatefulWidget {
  const EmployeesAll({Key? key}) : super(key: key);

  @override
  State<EmployeesAll> createState() => _EmployeesAllState();
}

class _EmployeesAllState extends State<EmployeesAll> {
  final listDropdownController1 = DropdownController();
  final listDropdownController2 = DropdownController();

  final List<String> list1 = <String>[
    'Default',
    'Salary',
    'Age',
    'Joining Date',
    'Rating',
  ];

  final List<String> list2 = <String>[
    'Default',
    'Ascending',
    'Descending',
  ];
  List<CoolDropdownItem<String>> dropdownItemList1 = [];
  List<CoolDropdownItem<String>> dropdownItemList2 = [];

  String dropdownValue1 = 'Default';
  String dropdownValue2 = 'Default';

  bool isValue1Changed = false;
  bool isValue2Changed = false;

  late String sortBy = "";
  late String sortOrder = "";
  late Timer timer;
  late Future<List<dynamic>> employees;

  void initState() {
    super.initState();

    for (var x in list1) {
      dropdownItemList1.add(CoolDropdownItem<String>(value: x, label: x));
    }

    for (var x in list2) {
      dropdownItemList2.add(CoolDropdownItem<String>(value: x, label: x));
    }

    fetchEmployees(null, null);

    // timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   setState(() {
    //     reload();
    //   });
    // });
  }

  void reload() {
    setState(() {
      fetchEmployees(sortBy.isNotEmpty ? sortBy : null,
          sortOrder.isNotEmpty ? sortOrder : null);
    });
  }

  void fetchEmployees(String? orderBy, String? order) {
    employees = FetchEmployee.fetchEmployee(orderBy, order);
  }

  void onChangeDropdown1(String value) {
    setState(() {
      dropdownValue1 = value;
      isValue1Changed = true;
      if (value == "Salary") {
        sortBy = "base_salary";
      } else if (value == "Age") {
        sortBy = "dateofbirth";
      } else if (value == "Joining Date") {
        sortBy = "joiningdate";
      } else if (value == "Rating") {
        sortBy = "rating";
      } else {
        sortBy = "";
      }
      reload();
    });
  }

  void onChangeDropdown2(String value) {
    setState(() {
      dropdownValue2 = value;
      isValue2Changed = true;
      sortOrder = (value == "Ascending")
          ? "ASC"
          : (value == "Descending")
              ? "DESC"
              : "";
      reload();
    });
  }

  Future<void> showSearchDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchEmployee(); // Assuming SearchEmployee is a StatelessWidget
      },
    );
  }

  // Replace the build method inside the _EmployeesAllState class with the following:

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
                    children: [
                      const Text(
                        'All Employees',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          showSearchDialog(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width / 6,
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade500),
                              const SizedBox(width: 10),
                              Text(
                                'Search',
                                style: TextStyle(color: Colors.grey.shade500),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(height: 10),
                // Container(
                //   height: 55,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border.all(color: Colors.grey.shade400, width: 2),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Container(
                //           padding: const EdgeInsets.only(left: 5),
                //           child: TextField(
                //             decoration: InputDecoration(
                //               hintText: 'Search Employee',
                //               hintStyle: TextStyle(color: Colors.grey.shade400),
                //               border: InputBorder.none,
                //               prefixIcon: const Icon(
                //                 Icons.search,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 10),
                //       Container(
                //         margin: const EdgeInsets.only(right: 5),
                //         height: 42,
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: CupertinoColors.activeBlue,
                //             foregroundColor: Colors.white,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           onPressed: () {
                //             // Implement search functionality
                //           },
                //           child: const Text('Search'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: CupertinoColors.activeBlue,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          // Implement filter functionality
                          reload();
                        },
                        icon: const Icon(Icons.loop),
                        label: const Text('Reload'),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Sort By:',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          child: CoolDropdown(
                            dropdownList: dropdownItemList1,
                            controller: listDropdownController1,
                            defaultItem: CoolDropdownItem<String>(
                                value: dropdownValue1, label: dropdownValue1),
                            onChange: onChangeDropdown1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Order: ',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          child: CoolDropdown(
                              dropdownList: dropdownItemList2,
                              controller: listDropdownController2,
                              defaultItem: CoolDropdownItem<String>(
                                  value: dropdownValue2, label: dropdownValue2),
                              onChange: onChangeDropdown2),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 50),
                FutureBuilder<List<dynamic>>(
                  future: employees,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No employees found.'));
                    } else {
                      return SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue.shade300),
                          headingTextStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          dataRowMaxHeight: 120,
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            verticalInside: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          columns: const [
                            DataColumn(
                                label: Text(
                              'Picture',
                            )),
                            DataColumn(
                                label:
                                    Text('Name', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Role', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Email', textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Address',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Phone', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Age', textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Joining Date',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Rating',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Salary',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Leaves',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Action',
                                    textAlign: TextAlign.center)),
                          ],
                          rows: snapshot.data!.map<DataRow>((employee) {
                            return DataRow(cells: [
                              DataCell(
                                FutureBuilder<String>(
                                  future: getImageLink(employee['profile_pic']),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    } else if (imageSnapshot.hasError) {
                                      return const Text('Error loading image');
                                    } else {
                                      return SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CachedNetworkImage(
                                          imageUrl: imageSnapshot.data!,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              DataCell(Text(employee['name'],
                                  textAlign: TextAlign.center)),
                              DataCell(Text(employee['role'])),
                              DataCell(SizedBox(
                                  width: 100, child: Text(employee['email']))),
                              DataCell(
                                SizedBox(
                                  width: 100,
                                  child: Text(getLocation(employee['address']),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 140,
                                  child: Text(
                                      getPhoneNumber(employee['phone_numbers']),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              DataCell(
                                Text(
                                    calculateAge(employee['dateofbirth'])
                                        .toString(),
                                    textAlign: TextAlign.center),
                              ),
                              DataCell(SizedBox(
                                  width: 110,
                                  child: Text(employee['joiningdate'],
                                      textAlign: TextAlign.center))),
                              DataCell(Text(employee['rating'].toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(
                                Text(employee['base_salary'].toString() + ' tk',
                                    textAlign: TextAlign.center),
                              ),
                              DataCell(Text(employee['leaves'].toString(),
                                  textAlign: TextAlign
                                      .center)), // Placeholder for leaves
                              DataCell(IconButton(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () {},
                              )),
                            ]);
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getImageLink(String? image) async {
    if (image == null || image.isEmpty) {
      return ''; // Return an empty string if no image is provided
    }
    // print(image); // Debugging purposes (optional)
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/${image}";
    // print(imageUrl); // Debugging purposes (optional)
    // Simulate delay to mimic network request
    await Future.delayed(const Duration(seconds: 1));
    return imageUrl;
  }

  String getLocation(String location) {
    List<String> loc = location.split('|');
    return "${loc[0]}, ${loc[1]}, ${loc[2]}, ${loc[3]}, ${loc[4]}, ${loc[5]}";
  }

  int calculateAge(String dateOfBirthString) {
    DateTime dob = DateTime.parse(dateOfBirthString);
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  String getPhoneNumber(String phoneNumbers) {
    List<String> phones = phoneNumbers.split(',');
    String phone = "";
    for (int i = 0; i < phones.length; i++) {
      phone += phones[i];
      if (i != phones.length - 1) {
        phone += ", ";
      }
    }
    return phone.trim();
  }
}
