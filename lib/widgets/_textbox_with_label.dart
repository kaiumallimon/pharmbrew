import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextBoxWithLabel extends StatefulWidget {
  const TextBoxWithLabel({super.key, required this.label, required this.hint, required this.controller, required this.disabled});

  @override
  State<TextBoxWithLabel> createState() => _TextBoxWithLabelState();
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool disabled;
}

class _TextBoxWithLabelState extends State<TextBoxWithLabel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text('${widget.label}', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          // padding: const EdgeInsets.symmetric(vertical: 10),
          width: 550,
          height: 50,
          // decoration: BoxDecoration(
          //   color: Colors.grey.shade300,
          //   borderRadius: BorderRadius.circular(5),
          // ),
          child: TextField(
            maxLines: 3,
            style: const TextStyle(color: Colors.black),
            controller: widget.controller,
            enabled: widget.disabled,

            decoration: InputDecoration(
              // contentPadding: const EdgeInsets.all(10),
              filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: CupertinoColors.activeGreen, width: 2.0),
                ),
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
