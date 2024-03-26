import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/_fetch_employee.dart';

class SearchEmployee extends StatefulWidget {
  const SearchEmployee({super.key});

  @override
  State<SearchEmployee> createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchEmployee> {
  late Future<List<dynamic>> employeesFuture;
  TextEditingController searchController = TextEditingController();
  List<dynamic> employees = [];
  List<dynamic> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    employeesFuture = FetchEmployee.fetchEmployee(null, null);
    employeesFuture.then((value) {
      setState(() {
        employees = value;
      });
    });
  }

  void filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = [];
      } else {
        filteredEmployees = employees
            .where((employee) => (employee['name'] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: SizedBox(
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  controller: searchController,
                  onChanged: filterEmployees,
                  decoration: const InputDecoration(
                    hintText: 'Search Employee',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: employees.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : filteredEmployees.isEmpty
                  ? const Center(child: Text('No results found.'))
                  : ListView.builder(
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return Container(
                          color: Colors.grey.shade200,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
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
                              const SizedBox(height: 10),
                              Text(
                                '${employee['name']}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${employee['designation']}',
                                style: const TextStyle(),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Role: ${employee['role']}',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Email: ${employee['email']}',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Department: ${employee['department_name']}',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Phone: ${getPhoneNumber(employee['phone_numbers'])}',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Address: ${getLocation(employee['address'])}',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }

  String getLocation(String location) {
    List<String> loc = location.split('|');
    return "${loc[0]}, ${loc[1]}, ${loc[2]}, ${loc[3]}, ${loc[4]}, ${loc[5]}";
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
