import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pharmbrew/data/_fetch_employee.dart';

import '../../../domain/_update_role.dart';
import '_search_employee.dart';

class RolesAndAccess extends StatefulWidget {
  const RolesAndAccess({Key? key}) : super(key: key);

  @override
  State<RolesAndAccess> createState() => _EmployeesAllState();
}

class _EmployeesAllState extends State<RolesAndAccess> {
  final listDropdownController1 = DropdownController();
  final listDropdownController2 = DropdownController();
  final TextEditingController searchController = TextEditingController();

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

    fetchEmployees(null, null);
  }

  void reload() {
    setState(() {
      fetchEmployees(null, null);
    });
  }

  void fetchEmployees(String? orderBy, String? order) {
    employees = FetchEmployee.fetchEmployee(orderBy, order);
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
                    'Roles & Access',
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          // Implement filter functionality
                          reload();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reload'),
                      ),
                    ),
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
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  Theme.of(context).colorScheme.primary),
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
                                label: Text('ID', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Name', textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Role', textAlign: TextAlign.center)),
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
                              DataCell(SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * (1 / 7),
                                child: Text(employee['userId']),
                              )),
                              DataCell(SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      (1 / 7),
                                  child: Text(employee['name']))),
                              DataCell(SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * (1 / 5),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text("HR"),
                                      leading: Radio<String>(
                                        value: "HR",
                                        groupValue:
                                            employee['role'],
                                        onChanged: (String? value) {
                                          setState(() {
                                            employee['role'] = value;

                                          });
                                          updateEmployeeRole(employee['userId'], value!);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Employee'),
                                      leading: Radio<String>(
                                        value: "Employee",
                                        groupValue: employee['role'],
                                        onChanged: (String? value) {

                                          updateEmployeeRole(employee['userId'], value!);

                                          setState(() {
                                            employee['role'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
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
        "https://bcrypt.site/uploads/images/profile/picture/$image";
    // print(imageUrl); // Debugging purposes (optional)
    // Simulate delay to mimic network request
    await Future.delayed(const Duration(seconds: 1));
    return imageUrl;
  }
}
