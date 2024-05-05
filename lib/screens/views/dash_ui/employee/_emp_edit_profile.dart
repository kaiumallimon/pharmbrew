import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/data/_check_pass.dart';
import 'package:pharmbrew/data/_update_password.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/utils/_show_dialog2.dart';
import 'package:pharmbrew/widgets/_textbox_with_label.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/_fetch_employee.dart';

class EmployeeEditProfile extends StatefulWidget {
  const EmployeeEditProfile({super.key});

  @override
  State<EmployeeEditProfile> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<EmployeeEditProfile> {
  @override
  void initState() {
    initData();
    delay();
    super.initState();
  }

  void delay() async {
    await Future.delayed(Duration(milliseconds: 500));
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return user.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('User Profile',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 70,
                        backgroundImage: CachedNetworkImageProvider(
                            getImageLink(user['profile_pic']))),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user['name'],
                        style: GoogleFonts.inter(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        // TextBoxWithLabel(
                        //     disabled: false,
                        //     label: 'Name',
                        //     hint: 'John Doe',
                        //     controller: nameController),
                        // const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: false,
                            label: 'Email',
                            hint: 'john@gmail.com',
                            controller: emailController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: false,
                            label: 'Phone',
                            hint: '+8801234567890',
                            controller: phoneController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: false,
                            label: 'Date of birth',
                            hint: '1989-10-2',
                            controller: dobController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: false,
                            label: 'Designation',
                            hint: 'Medical Writer',
                            controller: designationController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: false,
                            label: 'Address',
                            hint: 'Dhaka, Bangladesh',
                            controller: addressController),
                      ],
                    )),
                    const SizedBox(width: 30),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBoxWithLabel(
                            disabled: true,
                            label: 'Current Password',
                            hint: '******************',
                            controller: currentPasswordController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: true,
                            label: 'New Password',
                            hint: '******************',
                            controller: newPasswordController),
                        const SizedBox(height: 30),
                        TextBoxWithLabel(
                            disabled: true,
                            label: 'Confirm New Password',
                            hint: '******************',
                            controller: confirmNewPasswordController),
                        const SizedBox(height: 57),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 550,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (currentPasswordController.text.isEmpty ||
                                      newPasswordController.text.isEmpty ||
                                      confirmNewPasswordController
                                          .text.isEmpty) {
                                    showCustomErrorDialog(
                                        'Please enter all the data!', context);
                                  } else {
                                    if (newPasswordController.text !=
                                        confirmNewPasswordController.text) {
                                      showCustomErrorDialog(
                                          'New password and confirm password do not match!',
                                          context);
                                    } else {
                                      Map<String, dynamic> response =
                                          await CheckPassword.check(
                                              userId,
                                              currentPasswordController.text
                                                  .toString()
                                                  .trim());
                                      if (response['success']) {
                                        UpdatePassword.update(
                                            user['email'],
                                            newPasswordController.text
                                                .toString()
                                                .trim());

                                        showCustomSuccessDialog('Password Updated', context);
                                      } else {
                                        showCustomErrorDialog(
                                            'Password did not matched!',
                                            context);
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: Text(
                                  'Update Profile',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ],
                )
                // TextBoxWithLabel(label: 'Name', hint: 'John Doe', controller: nameController)
              ],
            ),
          );
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  List<dynamic> userData = [];
  Map<String, dynamic> user = {};

  void fetchUserData() async {
    var data = await FetchEmployee.fetchEmployee(null, null);
    for (var i in data) {
      if (i['userId'] == userId) {
        setState(() {
          user = i;
        });
        print('User found: $user');
        break;
      }
    }

    if (user.isNotEmpty) {
      setState(() {
        nameController.text = user['name'];
        emailController.text = user['email'];
        dobController.text = user['dateofbirth'];
        phoneController.text = user['phone_numbers'];
        designationController.text = user['designation'];
        addressController.text = user['address'].replaceAll("| ", ", ").replaceAll("|", ", ");
      });
    }
  }

  late String userId = '';

  void initData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('loggedInUserId') ?? '';
    });
  }

  String getImageLink(String image) {
    if (image == null || image.isEmpty) {
      return ''; // Return an empty string if no image is provided
    }
    String imageUrl =
        "https://bcrypt.site/uploads/images/profile/picture/$image";

    return imageUrl;
  }
}
