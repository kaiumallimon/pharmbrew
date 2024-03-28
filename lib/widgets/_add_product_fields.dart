import 'package:flutter/material.dart';

class AddProductFields extends StatefulWidget {
  AddProductFields({super.key, required this.controller, required this.labelText, this.readOnly=false, this.initialValue='0'});

  final TextEditingController controller;
  final String labelText;
  bool readOnly=false;
  String initialValue = '0';

  @override
  State<AddProductFields> createState() => _AddProductFieldsState();
}

class _AddProductFieldsState extends State<AddProductFields> {
  @override
  void initState() {
    super.initState();

    if(widget.readOnly){
      widget.controller.text = widget.initialValue;
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(

        readOnly: widget.readOnly,
        controller: widget.controller,
        textAlign: widget.readOnly? TextAlign.center: TextAlign.start,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          labelText: widget.labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green.shade500,
                width: 2
            ),
          ),
        ),
      ),
    );
  }
}
