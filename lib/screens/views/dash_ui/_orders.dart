import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmbrew/widgets/_add_product_fields.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                'Orders',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            color: Theme.of(context).colorScheme.primary,
                            child: Center(
                              child: Text(
                                'Customers Info',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        height: 40,
                        color: Theme.of(context).colorScheme.primary,
                        child: Center(
                          child: Text(
                            'Products',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AddProductFields(
                        controller: nameController,
                        labelText: 'Product Name',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AddProductFields(
                        controller: variantController,
                        labelText: 'Product Variant',
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: AddProductFields(
                            controller: quantityController,
                            readOnly: true,
                            labelText: "Product Quantity",
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onLongPress: _startTimer,
                              onLongPressUp: _stopTimer,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    String text = quantityController.text;
                                    int quantity = int.parse(text);
                                    setState(() {
                                      quantityController.text =
                                          (quantity + 1).toString();
                                    });
                                  },
                                  child: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(10),
                                        ),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isProductFound = !isProductFound;
                                  });
                                },
                                child: Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(
                                      color:
                                      Theme.of(context).colorScheme.primary,
                                      width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      !isProductFound
                          ? Text(
                              'Product Not Available!',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox.shrink(),
                    ],
                  )),
                ],
              )
            ],
          ),
        )));
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController variantController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  bool isProductFound = true;

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _counter++;
        quantityController.text = _counter.toString();
      });
    });
  }

  Timer? _timer;
  int _counter = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
