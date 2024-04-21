import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_fetch_employee.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';

import '../../../data/_remove_user.dart';
import '_search_employee.dart';

class EmployeesAll extends StatefulWidget {
  const EmployeesAll({Key? key}) : super(key: key);

  @override
  State<EmployeesAll> createState() => _EmployeesAllState();
}

class _EmployeesAllState extends State<EmployeesAll> {
  final listDropdownController1 = DropdownController();
  final listDropdownController2 = DropdownController();
  final TextEditingController searchController = TextEditingController();

  final List<String> list1 = <String>[
    'Default',
    'Salary',
    // 'Age',
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

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();

    for (var x in list1) {
      dropdownItemList1.add(CoolDropdownItem<String>(value: x, label: x));
    }

    for (var x in list2) {
      dropdownItemList2.add(CoolDropdownItem<String>(value: x, label: x));
    }

    fetchEmployees(null, null);

    // timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
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
      }
      // } else if (value == "Age") {
      //   sortBy = "dateofbirth";
      // }
      else if (value == "Joining Date") {
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
        return const SearchEmployee(); // Assuming SearchEmployee is a StatelessWidget
      },
    );
  }

  List<dynamic> filteredEmployees(List<dynamic> employees, String query) {
    if (query.isEmpty) {
      return employees;
    }

    return employees.where((employee) {
      return employee['name'].toLowerCase().contains(query.toLowerCase()) ||
          employee['role'].toLowerCase().contains(query.toLowerCase()) ||
          employee['email'].toLowerCase().contains(query.toLowerCase()) ||
          getLocation(employee['address'])
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          getPhoneNumber(employee['phone_numbers'])
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          calculateAge(employee['dateofbirth'])
              .toString()
              .contains(query.toLowerCase()) ||
          employee['joiningdate'].toLowerCase().contains(query.toLowerCase()) ||
          employee['rating'].toString().contains(query.toLowerCase()) ||
          employee['base_salary'].toString().contains(query.toLowerCase()) ||
          employee['leaves'].toString().contains(query.toLowerCase());
    }).toList();
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
                  child: const Text(
                    'All Employees',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
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
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Employees',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 45,
                      // height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          // Implement filter functionality
                          reload();
                        },
                        icon: const Icon(Icons.refresh),
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
                      final List<dynamic> filteredList = filteredEmployees(
                          snapshot.data!, searchController.text);
                      return SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context).colorScheme.primary),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          dataRowMaxHeight: 120,
                          border: TableBorder.all(color: Colors.grey.shade300),
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
                          rows: filteredList.map<DataRow>((employee) {
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
                                  width: 140,
                                  child: Text(getLocation(employee['address']),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 120,
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
                                Text('${employee['base_salary']} tk',
                                    textAlign: TextAlign.center),
                              ),
                              DataCell(SizedBox(
                                width: 40,
                                child: Text(employee['leaves'].toString(),
                                    textAlign: TextAlign
                                        .center),
                              )), // Placeholder for leaves
                              DataCell(
                                PopupMenuButton(
                                  surfaceTintColor: Theme.of(context).colorScheme.primary,
                                  color: Colors.white,
                                  icon: const Icon(Icons.more_horiz),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: TextButton.icon(
                                        onPressed: (){
                                          String user=employee['userId'];
                                          RemoveUser.remove(employee['userId']);
                                          setState(() {
                                            snapshot.data!.removeWhere((element) => element['userId']==user);
                                          });
                                          showCustomSuccessDialog('Removal Successful!', context);
                                        },
                                        icon: const Icon(Icons.delete),
                                        label: Text('Remove Employee'),
                                      ),
                                    ),

                                    PopupMenuItem(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          showCustomErrorDialog('Coming Soon!', context);
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Edit Employee'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        "https://bcrypt.site/uploads/images/profile/picture/$image";
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
