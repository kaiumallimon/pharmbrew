import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_fetch_employee.dart';

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

  late Future<List<dynamic>> employees;

  @override
  void initState() {
    super.initState();

    for (var x in list1) {
      dropdownItemList1.add(CoolDropdownItem<String>(value: x, label: x));
    }

    for (var x in list2) {
      dropdownItemList2.add(CoolDropdownItem<String>(value: x, label: x));
    }

    fetchEmployees();
  }

  void fetchEmployees() {
    employees = FetchEmployee.fetchEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              color: Colors.white,
              child: const Text(
                'All Employees',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Employee',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.activeBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Implement search functionality
                      },
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
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
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
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
                        onChange: (value) {
                          setState(() {
                            dropdownValue1 = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('Order By:',
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
                        onChange: (value) {
                          setState(() {
                            dropdownValue2 = value!;
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: employees,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No employees found.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var employee = snapshot.data![index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 20),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       IconButton(
                              //           onPressed: () {},
                              //           icon: Icon(Icons.more_horiz))
                              //     ],
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: FutureBuilder<String>(
                                      future:
                                          getImageLink(employee['profile_pic']),
                                      builder: (context, imageSnapshot) {
                                        if (imageSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox(
                                              width: 200,
                                              height: 300,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        } else if (imageSnapshot.hasError) {
                                          return Text('Error loading image');
                                        } else {
                                          return SizedBox(
                                            height: 300,
                                            width: 200,
                                            child: CachedNetworkImage(
                                              imageUrl: imageSnapshot.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 20),
                                  // Add other employee information as needed
                                  //row for name and email
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${employee['name']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8), // Add spacing
                                      Text(
                                        'Role: ${employee['role']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.red,
                                        ),
                                      ),

                                      const SizedBox(height: 8), // Add spacing
                                      Text(
                                        'Email: ${employee['email']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Add spacing

                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            2, // or any specific width you want
                                        child: Text(
                                          'Address: ${getLocation(employee['address'])}',
                                          maxLines: 2,
                                          softWrap: true,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            2, // or any specific width you want
                                        child: Text(
                                          'Phone: ${getPhoneNumber(employee['phone_numbers'])}',
                                          maxLines: 2,
                                          softWrap: true,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8), // Add spacing

                                      Text(
                                        'Age: ${calculateAge(employee['dateofbirth'])}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Add spacing

                                      Text(
                                        'Joining Date: ${employee['joiningdate']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Add spacing

                                      Text(
                                        'Rating: ${employee['rating']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 8), // Add spacing

                                      Text(
                                        'Salary: ${employee['base_salary']} tk',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Add spacing
                                    ],
                                  ),
                                ],
                              ),

                              // Add other employee information as needed
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getImageLink(String? image) async {
    if (image == null || image.isEmpty) {
      return ''; // Return an empty string if no image is provided
    }
    print(image); // Debugging purposes (optional
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/${image}";
    print(imageUrl); // Debugging purposes (optional
    // Simulate delay to mimic network request
    await Future.delayed(Duration(seconds: 1));
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
