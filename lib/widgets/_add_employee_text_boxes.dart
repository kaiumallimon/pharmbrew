import 'package:flutter/material.dart';

class AddEmployeeTextBoxes extends StatelessWidget {
  const AddEmployeeTextBoxes(
      {super.key, required this.title, required this.hintText, required this.controller});

  final String title;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: const <TextSpan>[
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
              width: MediaQuery.of(context).size.width / 2.3,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
