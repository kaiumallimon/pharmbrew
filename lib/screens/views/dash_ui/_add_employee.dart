import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pharmbrew/domain/_generate_password.dart';
import 'package:pharmbrew/domain/_mailer.dart';
import 'package:pharmbrew/domain/_register.dart';
import 'package:pharmbrew/widgets/_add_employee_text_boxes.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';

import '../../../domain/usecases/_get_department_and_id.dart';
import '../../../utils/_show_dialog.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _baseSalaryController = TextEditingController();
  final TextEditingController _paymentFrequencyController =
      TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  final List<String> departmentNames = getAllDesignations();

  bool verficationSent = false;

  XFile? _image;

  String dropDownValue = "";

  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),
            child: const Row(
              children: [
                Text(
                  'Add New Employee',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                AddEmployeeTextBoxes(
                  controller: _fnameController,
                  title: 'First Name',
                  hintText: 'Enter First Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _lnameController,
                  title: 'Last Name',
                  hintText: 'Enter last Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Email',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Email Address',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () async {
                                    String email =
                                        _emailController.text.toString().trim();

                                    // print(email);

                                    final bool isValid =
                                        EmailValidator.validate(email);

                                    // Check if email field is empty
                                    if (email.isEmpty || !isValid) {
                                      // Show error dialog if email field is empty
                                      showCustomErrorDialog(
                                          "Please enter a valid email address",
                                          context);
                                    } else {
                                      // Generate OTP
                                      generatedOTP = generateOTP();
                                      sendEmail(
                                          email,
                                          "Pharmabrew Verification Code",
                                          "Dear user,\nHere is your verification code: $generatedOTP");

                                      // Update state
                                      setState(() {
                                        verficationSent = true;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      verficationSent
                                          ? const Icon(
                                              Icons.loop,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        verficationSent
                                            ? 'Resend'
                                            : 'Send verification code',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AddEmployeeTextBoxes(
                  controller: _verificationController,
                  title:
                      "Verification Code [Don't Forget To Check Spam Folder]",
                  hintText: 'Enter Verification Code From Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _roleController,
                  title: 'Login Role',
                  hintText: 'Enter Role',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _dobController,
                  title: 'Date of Birth',
                  hintText: 'Year-Month-Day',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _designationController,
                  title: 'Designation',
                  hintText: 'Enter Designation',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _baseSalaryController,
                  title: 'Base Salary',
                  hintText: 'Enter Base Salary',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _paymentFrequencyController,
                  title: 'Payment Frequency',
                  hintText: 'Enter Payment Frequency',
                ),
                const SizedBox(
                  height: 10,
                ),
                // AddEmployeeTextBoxes(
                //   controller: _departmentController,
                //   title: 'Department',
                //   hintText: 'Enter Department',
                // ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: "Department",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: DropdownMenu<String>(
                            initialSelection: departmentNames.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropDownValue = value!;
                              });

                              print(
                                  "Selected: ${getDepartmentIdByDesignation(dropDownValue)}");
                            },
                            dropdownMenuEntries: departmentNames
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _ratingController,
                  title: 'Rating',
                  hintText: 'Enter Rating',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _phoneNumberController,
                  title: 'Phone Number',
                  hintText:
                      'Enter Phone Number (separated by comma if multiple)',
                ),
                const SizedBox(
                  height: 10,
                ),
                AddEmployeeTextBoxes(
                  controller: _skillsController,
                  title: 'Skills',
                  hintText: 'Enter Skills (separated by comma)',
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const Row(
                      children: [
                        Text('Location: ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Apartment: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _apartmentController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Apartment Number',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Building: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _buildingController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Building Name',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Street: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _streetController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Street Name/Number',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('City: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter City Name',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Postal Code: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _postalCodeController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Postal Code',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Country: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                controller: _countryController,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 2.0),
                                    ),
                                    hintText: 'Enter Country Name',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.3,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          _image = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _image = _image;
                            isSelected = true;
                            imageName = _image!.name;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey.shade400, width: 2.0),
                                borderRadius: BorderRadius.circular(10))),
                        child: isSelected
                            ? Text(
                                imageName,
                                style: const TextStyle(color: Colors.black),
                              )
                            : const Text('Select Picture',
                                style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      // width: 140,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String fname =
                                  _fnameController.text.toString().trim();
                              String lname =
                                  _lnameController.text.toString().trim();
                              String email =
                                  _emailController.text.toString().trim();
                              String verificationCode = _verificationController
                                  .text
                                  .toString()
                                  .trim();
                              String dob =
                                  _dobController.text.toString().trim();
                              String designation =
                                  _designationController.text.toString().trim();
                              String baseSalary =
                                  _baseSalaryController.text.toString().trim();
                              String paymentFrequency =
                                  _paymentFrequencyController.text
                                      .toString()
                                      .trim();
                              String department =
                                  _departmentController.text.toString().trim();
                              String rating =
                                  _ratingController.text.toString().trim();
                              String phoneNumber =
                                  _phoneNumberController.text.toString().trim();
                              String skills =
                                  _skillsController.text.toString().trim();
                              String apartment =
                                  _apartmentController.text.toString().trim();
                              String building =
                                  _buildingController.text.toString().trim();
                              String street =
                                  _streetController.text.toString().trim();
                              String city =
                                  _cityController.text.toString().trim();
                              String postalCode =
                                  _postalCodeController.text.toString().trim();
                              String country =
                                  _countryController.text.toString().trim();
                              String role =
                                  _roleController.text.toString().trim();

                              if (_fnameController.text.trim().isEmpty ||
                                  _lnameController.text.trim().isEmpty ||
                                  _emailController.text.trim().isEmpty ||
                                  _verificationController.text.trim().isEmpty ||
                                  _dobController.text.trim().isEmpty ||
                                  _designationController.text.trim().isEmpty ||
                                  _baseSalaryController.text.trim().isEmpty ||
                                  _paymentFrequencyController.text
                                      .trim()
                                      .isEmpty ||
                                  _departmentController.text.trim().isEmpty ||
                                  _ratingController.text.trim().isEmpty ||
                                  _phoneNumberController.text.trim().isEmpty ||
                                  _skillsController.text.trim().isEmpty ||
                                  _apartmentController.text.trim().isEmpty ||
                                  _buildingController.text.trim().isEmpty ||
                                  _streetController.text.trim().isEmpty ||
                                  _cityController.text.trim().isEmpty ||
                                  _postalCodeController.text.trim().isEmpty ||
                                  _countryController.text.trim().isEmpty ||
                                  _roleController.text.trim().isEmpty) {
                                // At least one field is empty
                                showCustomErrorDialog(
                                    "Pleas fill all the fields!", context);
                              } else {
                                // All fields are filled
                                if (generatedOTP == verificationCode) {
                                  String password = generateRandomPassword();

                                  String? department_id =
                                      getDepartmentIdByDesignation(
                                          dropDownValue);

                                  createUser(
                                      "$fname $lname",
                                      email,
                                      dob,
                                      designation,
                                      password,
                                      role,
                                      _image,
                                      rating,
                                      department_id.toString(),
                                      skills,
                                      "$apartment, $building, $street, $city, $postalCode, $country",
                                      phoneNumber,
                                      baseSalary,
                                      context);
                                } else {
                                  showCustomErrorDialog(
                                      "Invalid OTP!", context);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CupertinoColors.activeBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text('Register Employee',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  late String generatedOTP;
  late String imageName;
  bool isSelected = false;

  String generateOTP() {
    Random random = Random();
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += random.nextInt(10).toString();
    }

    return code;
  }
}
