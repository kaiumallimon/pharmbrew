import 'package:flutter/material.dart';

class MyExpandableWidgetLists extends StatefulWidget {
  const MyExpandableWidgetLists(
      {super.key, required this.listItems, required this.listTitle});
  final List<Widget> listItems;
  final String listTitle;

  @override
  State<MyExpandableWidgetLists> createState() =>
      _MyExpandableWidgetListsState();
}

class _MyExpandableWidgetListsState extends State<MyExpandableWidgetLists> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.listTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ))
              ],
            ),
          ),
        ),
        isExpanded
            ? Column(
                children: widget.listItems,
              )
            : const SizedBox(
                width: 0,
                height: 0,
              ),
      ],
    );
  }
}
