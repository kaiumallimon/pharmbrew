import 'package:pharmbrew/domain/_mailer.dart';

import '../utils/_show_dialog.dart';
import '../widgets/_successful_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

Future<void> createUser(
    String name,
    String email,
    String dateOfBirth,
    String designation,
    String password,
    String role,
    XFile? imageFile,
    String rating,
    String departmentId,
    String skills,
    String location,
    String phone,
    String baseSalary,
    BuildContext context) async {
  var url = 'https://bcrypt.site/scripts/php/register.php';

  // Sample data to send to the API

  print("Name: $name");
  print("Email: $email");
  print("Date of Birth: $dateOfBirth");
  print("Designation: $designation");
  print("Password: $password");
  print("Role: $role");
  print("Rating: $rating");
  print("Department ID: $departmentId");
  print("Skills: $skills");
  print("Location: $location");
  print("Phone: $phone");
  print("Base Salary: $baseSalary");
  print("Image File: ${imageFile!.name}");

  var data = {
    'name': name,
    'email': email,
    'dateofbirth': dateOfBirth,
    'designation': designation,
    'password': password,
    'role': role,
    'profile_pic': 'profile_pic.img',
    'rating': rating,
    'department_id': departmentId,
    'skills': skills,
    'location': location,
    'phone_numbers': phone,
    'base_salary': baseSalary,
    // Add other required fields here
  };

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add form data
    request.fields.addAll(data);

    // Add image file
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: 'image.jpg',
    );
    request.files.add(multipartFile);

    // Send request
    var response = await request.send();

// // Convert the response stream to a string
//     var result = await response.stream.bytesToString();

// // Now you can decode the string
//     var decodedResult = json.decode(result);

//     print(decodedResult);

    // Get response
    if (response.statusCode == 200) {
      // Map<String, dynamic> result = jsonDecode(finalResponse.body);

      // if (result['success'] == true) {
      showCustomSuccessDialog('Account created successfully', context);

      sendEmail(email, "Regarding Pharmabrew Account",
          "Dear user,\nYour account has been created successfully. Now you can login to your account with these credentials: \n\nEmail: $email\nPassword: $password\n\nThank you for choosing Pharmabrew!");
      return;
      // } else {
      // showCustomErrorDialog(result['message'], context);
      // }
    } else {
      showCustomErrorDialog(
          'Failed with status code: ${response.statusCode}', context);
    }
  } catch (e) {
    // print('Exception: $e');
    showCustomErrorDialog('Exception: $e', context);
  }
}
