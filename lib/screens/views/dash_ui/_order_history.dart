import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/_fetch_orders.dart';
import '../../../utils/_show_dialog.dart';
import '../../../utils/_show_dialog2.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> orderHistory = [];
  List<dynamic> filteredOrderHistory = [];

  @override
  void initState() {
    getOrderHistory();
    super.initState();
  }

  void getOrderHistory() async {
    var data = await FetchOrders.fetch();
    setState(() {
      orderHistory = data;
      filteredOrderHistory = data; // Initially set filtered list to full list
    });
  }

  void filterOrders(String query) {
    setState(() {
      filteredOrderHistory = orderHistory
          .where((order) =>
          order['customerName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order History',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          filterOrders(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Orders By Customer Name',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              filteredOrderHistory.isNotEmpty
                  ? Container(
                width: double.infinity,
                height: 690,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: Text(
                              'Index',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 300,
                            child: Text(
                              'Customer Name',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 250,
                            child: Text(
                              'Customer Email',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 150,
                            child: Text(
                              'Customer Phone',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              "Order Date",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: Text(
                              'Total Bill',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Action',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrderHistory.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: Text('${index + 1}'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  child: Text(
                                    filteredOrderHistory[index]['customerName'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 250,
                                  child: Text(
                                    filteredOrderHistory[index]['customerEmail'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 150,
                                  child: Text(filteredOrderHistory[index]['customerPhone']),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Text(filteredOrderHistory[index]['orderDate']
                                      .toString()
                                      .split(' ')[0]),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Text(filteredOrderHistory[index]['totalCost']),
                                ),
                                Container(
                                  child: PopupMenuButton(
                                    surfaceTintColor: Theme.of(context).colorScheme.primary,
                                    color: Colors.white,
                                    icon: const Icon(Icons.more_horiz),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                                          child: ListTile(
                                            title: Text('View Full Details'),
                                            onTap: () {
                                              Navigator.pushNamed(context, '/order-details',
                                                  arguments: filteredOrderHistory[index]);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
                  : Container(
                height: 400,
                alignment: Alignment.center,
                child: Text(
                  'No orders found for this customer!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
