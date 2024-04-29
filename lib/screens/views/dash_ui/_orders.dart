import 'dart:async';
import 'dart:html';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/utils/_show_dialog2.dart';
import 'package:pharmbrew/widgets/_add_product_fields.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/_fetch_products_quantity.dart';
import '../../../data/_place_order.dart';
import '../../../data/_send_mail_with_attachment.dart';
import '../../../domain/_fetch_products.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<List<String>> allProducts = [];
  List<List<String>> filteredData = [];
  List<String> suggestions = [];
  List<String> variantNames = [];
  List<Map<String, dynamic>> cartItems = [];
  double width = 0.0;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchProductsLocal(allProducts);
    filteredData = List.from(allProducts); // Initialize filteredData
  }

  String quantityLeft = '';

  bool isLoading = true;

  void fetchProductsLocal(List<List<String>> allProductsList) async {
    try {
      allProductsList.clear();

      List<dynamic> productsList = await fetchProducts();

      setState(() {
        for (var product in productsList) {
          List<String> productData = [];
          productData.add(product['product_id']);
          productData.add(product['productName']);
          productData.add(product['variant']);
          productData.add(product['productionDate']);
          productData.add(product['expDate']);
          productData.add(product['unitPerStrips']);
          productData.add(product['unitPrice']);
          productData.add(product['quantity']);
          allProductsList.add(productData);

          print('Product data: $productData');
        }
        isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading state to false in case of error too
      });
    }
  }

  bool isExpanded = false;

  void filterData(String query) {
    setState(() {
      suggestions = [];
      if (query.isEmpty) {
        filteredData = List.from(allProducts);
      } else {
        filteredData = allProducts.where((row) {
          if (row[1].toLowerCase().contains(query.toLowerCase())) {
            suggestions.add('${row[1]} - ${row[2]}');
            return true;
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoadingFullScreen?Center(
            child: CircularProgressIndicator(),
          ) : ListView(
            children: [
              const Text(
                'Place An Order',
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
                          child: const Center(
                            child: Text(
                              'Product',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Text field with suggestions
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) async {
                                  filterData(value);

                                  if (value.trim().isEmpty) {
                                    setState(() {
                                      quantityController.text = '0';
                                      quantityLeft = '';
                                    });
                                  }
                                },
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  labelText: 'Product Name',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green.shade500, width: 2),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Suggestions displayed below the text field
                        if (suggestions.isNotEmpty)
                          Container(
                            height: 150,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: suggestions
                                    .map((suggestion) => ListTile(
                                          title: Text(suggestion),
                                          onTap: () async {
                                            nameController.text = suggestion;
                                            setState(() {
                                              suggestions = [];
                                            });

                                            String name = suggestion;
                                            var data =
                                                await FetchProductsQuantity
                                                    .fetch(name);
                                            print('Product data: $data');
                                            if (data != null) {
                                              setState(() {
                                                quantityLeft =
                                                    data['quantity'].toString();
                                              });
                                            }
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        suggestions.isNotEmpty
                            ? const SizedBox(
                                height: 15,
                              )
                            : const SizedBox.shrink(),

                        quantityLeft == ''
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Product left: '),
                                  Text(
                                    '$quantityLeft',
                                    style: TextStyle(
                                        color: quantityLeft == '0'
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),

                        quantityLeft == ''
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: 15,
                              ),

                        Row(
                          children: [
                            Expanded(
                              child: AddProductFields(
                                controller: quantityController,
                                readOnly: false,
                                labelText: "Product Quantity",
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
                              child: MouseRegion(
                                onEnter: (event) {
                                  setState(() {
                                    isHoveringButton1 = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    isHoveringButton1 = false;
                                  });
                                },
                                child: Container(
                                  // duration: const Duration(seconds: 2),
                                  // curve: Curves.easeInOut,
                                  height: 50,

                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (nameController.text
                                                .trim()
                                                .isNotEmpty &&
                                            quantityController.text
                                                .trim()
                                                .isNotEmpty) {
                                          setState(() {
                                            isProductFound = !isProductFound;
                                          });

                                          int quantityGiven = int.parse(
                                              quantityController.text
                                                  .toString()
                                                  .trim());

                                          if (quantityGiven >
                                              int.parse(quantityLeft)) {
                                            showCustomErrorDialog(
                                                'Not enough quantity!',
                                                context);
                                          } else {
                                            Map<String, dynamic> productInfo =
                                                getSelectedProuctInfo(
                                                    nameController.text);
                                            cartItems.add(productInfo);

                                            print('Cart items: $cartItems');

                                            nameController.clear();
                                            quantityController.clear();
                                            quantityLeft = '';
                                          }
                                        } else {
                                          showCustomErrorDialog(
                                              'Product Name/Quantity Missing!',
                                              context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isHoveringButton1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : Colors.white,
                                        foregroundColor: isHoveringButton1
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        shape: const RoundedRectangleBorder(),
                                        side: BorderSide(
                                            color: isHoveringButton1
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            width: 2),
                                      ),
                                      child: Text(
                                        "Add to Cart",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: isHoveringButton1
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Show message when product is not found in filteredData
                        if (filteredData.isEmpty &&
                            !isLoading &&
                            nameController.text.isNotEmpty)
                          const Text(
                            'Product Not Available!',
                            style: TextStyle(color: Colors.red),
                          ),

                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 40,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Center(
                            child: Text(
                              'Customer',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AddProductFields(
                                controller: customerNameController,
                                labelText: 'Customer Name',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AddProductFields(
                                controller: customerEmailController,
                                labelText: 'Customer Email',
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AddProductFields(
                                controller: customerPhoneController,
                                labelText: 'Customer Phone',
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AddProductFields(
                                controller: customerBillingController,
                                labelText: 'Billing Info',
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MouseRegion(
                                onEnter: (event) {
                                  setState(() {
                                    isHoveringButton2 = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    isHoveringButton2 = false;
                                  });
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (customerNameController.text
                                              .trim()
                                              .isNotEmpty &&
                                          customerEmailController.text
                                              .trim()
                                              .isNotEmpty &&
                                          customerPhoneController.text
                                              .trim()
                                              .isNotEmpty &&
                                          customerBillingController.text
                                              .trim()
                                              .isNotEmpty) {
                                        bool isValidEmail =
                                            EmailValidator.validate(
                                                customerEmailController.text);

                                        if (isValidEmail) {
                                          setState(() {
                                            customerInfo['name'] =
                                                customerNameController.text;
                                            customerInfo['email'] =
                                                customerEmailController.text;
                                            customerInfo['phone'] =
                                                customerPhoneController.text;
                                            customerInfo['billing'] =
                                                customerBillingController.text;

                                            customerNameController.clear();
                                            customerEmailController.clear();
                                            customerPhoneController.clear();
                                            customerBillingController.clear();
                                          });
                                        } else {
                                          showCustomErrorDialog(
                                              'Please enter a valid email!',
                                              context);
                                        }
                                      } else {
                                        showCustomErrorDialog(
                                            'Please fill all the data!',
                                            context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isHoveringButton2
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Colors.white,
                                      foregroundColor: isHoveringButton2
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      shape: const RoundedRectangleBorder(),
                                      side: BorderSide(
                                          color: isHoveringButton2
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .background
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          width: 2),
                                    ),
                                    child: Text(
                                      'Save Customer Info',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: isHoveringButton2
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Center(
                            child: Text(
                              'Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        customerInfo.isNotEmpty
                            ? Column(
                                children: [
                                  Row(children: [
                                    Expanded(
                                      child:
                                          Text('Name: ${customerInfo['name']}'),
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                          'Phone: ${customerInfo['phone']}'),
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                          'Email: ${customerInfo['email']}'),
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                          'Billing Info: ${customerInfo['billing']}'),
                                    ),
                                  ])
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: 10,
                        ),
                        cartItems.isNotEmpty
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 670,
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                          headingTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          dataTextStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                          border: TableBorder.all(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                          headingRowColor:
                                              MaterialStateProperty.all(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          columns: const [
                                            DataColumn(label: Text('Name')),
                                            DataColumn(label: Text('Variant')),
                                            DataColumn(label: Text('Quantity')),
                                            DataColumn(label: Text('Price')),
                                            DataColumn(label: Text('Action')),
                                          ],
                                          rows: [
                                            // Your cart items
                                            for (var item in cartItems)
                                              DataRow(cells: [
                                                DataCell(Text(item['name'])),
                                                DataCell(Text(item['variant'])),
                                                DataCell(Text(
                                                    item['quantity (strips)'])),
                                                DataCell(Text(
                                                    item['price'].toString())),
                                                DataCell(IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      cartItems.remove(item);
                                                    });
                                                  },
                                                )),
                                              ]),
                                            // Extra row for total price
                                            DataRow(cells: [
                                              const DataCell(Text('Total Price',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                              const DataCell(Text('')),
                                              // Variant column is empty for total price
                                              const DataCell(Text('')),
                                              // Quantity column is empty for total price
                                              DataCell(
                                                Text(
                                                  calculateTotalPrice(),
                                                  // Call a function to calculate total price
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataCell(
                                                Text(''),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                height: 670,
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                      BorderSide(color: Colors.grey.shade300)),
                                ),
                                child: const Center(
                                  child: Text('No products added yet'),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async{
                          if (cartItems.isNotEmpty) {
                            if (customerInfo.isNotEmpty) {
                              setState(() {
                                isLoadingFullScreen=true;
                              });



                              //at first update data in the database

                              bool isOrderPlaced = await PlaceOrder.place(cartItems, customerInfo, userId, name);

                              if(isOrderPlaced){
                                // then send the mail with attachment
                                generatePDF(customerInfo, cartItems);
                                setState(() {
                                  isLoadingFullScreen=false;
                                  cartItems.clear();
                                  customerInfo.clear();
                                });
                              }else{
                                setState(() {
                                  isLoadingFullScreen=false;
                                });
                                showCustomErrorDialog('Failed to place order!', context);
                              }

                            } else {
                              showCustomErrorDialog(
                                  'Please save customer info!', context);
                            }
                          } else {
                            showCustomErrorDialog(
                                'Please add products to the cart!', context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: const Text('Place Order'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> customerInfo = {};

  final TextEditingController nameController = TextEditingController();
  final TextEditingController variantController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerBillingController =
      TextEditingController();
  bool isProductFound = true;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _counter++;
        quantityController.text = _counter.toString();
      });
    });
  }

  void _startTimer2() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
          quantityController.text = _counter.toString();
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Map<String, dynamic> getSelectedProuctInfo(String name) {
    Map<String, dynamic> productInfo = {};
    for (var product in allProducts) {
      String localName = '${product[1]} - ${product[2]}';
      if (localName == name) {
        productInfo['product_id'] = product[0];
        productInfo['name'] = product[1];
        productInfo['variant'] = product[2];
        productInfo['productionDate'] = product[3];
        productInfo['expDate'] = product[4];
        productInfo['quantity (strips)'] =
            quantityController.text.toString().trim();
        productInfo['price'] = double.parse(product[5]) *
            double.parse(product[6]) *
            double.parse(productInfo['quantity (strips)']);
        break;
      }
    }
    return productInfo;
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

  String calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item['price'];
    }
    return totalPrice.toString();
  }

  bool isHoveringButton1 = false;
  bool isHoveringButton2 = false;
  bool isHoveringButton3 = false;

  late String name = '';

  late String userId = '';

  void initSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('loggedInUserName') ?? '';
      userId = prefs.getString('loggedInUserId') ?? '';
    });
  }

  Future<void> generatePDF(Map<String, dynamic> invoiceData,
      List<Map<String, dynamic>> cartItems) async {
// Create a PDF document
    final pdf = pw.Document();

// Add content to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Invoice',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('This is an auto-generated invoice.',
                          style: pw.TextStyle(
                              fontSize: 13, color: PdfColors.grey)),
                    ]),
                pw.SizedBox(height: 20),
// Add invoice data from the map
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Text(
                      'Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                      style: pw.TextStyle(fontSize: 13, color: PdfColors.grey)),
                ]),
                pw.SizedBox(height: 20),
                for (var entry in invoiceData.entries)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Receiver ${entry.key}: ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Expanded(child: pw.Text(entry.value)),
                    ],
                  ),
                pw.SizedBox(height: 20),
// Add table for cart items
                pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    ['Name', 'Variant', 'Quantity', 'Price'],
// Rows for cart items
                    for (var item in cartItems)
                      [
                        item['name'],
                        item['variant'],
                        item['quantity (strips)'],
                        item['price'].toString()
                      ],
                  ],
                  border: pw.TableBorder.all(
                    color: PdfColors.grey,
                    width: 1,
                  ),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: const pw.TextStyle(),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Price: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(calculateTotalPrice()),
                  ],
                ),
                pw.SizedBox(height: 20),

                pw.Row(children: [
                  pw.Text(
                      "Thank you for your purchase, you're always welcomed to pharmabrew!",
                      style: pw.TextStyle(fontSize: 13, color: PdfColors.grey)),
                ]),
                pw.SizedBox(height: 30),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Column(children: [
                    pw.Text(
                      name.isNotEmpty
                          ? '${name.toString().trim().split(' ').first}'
                          : 'Pharmabrew',
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Container(
                      color: PdfColors.grey,
                      width: 150,
                      height: 1,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Sold by',
                      style: pw.TextStyle(
                        color: PdfColors.grey,
                      ),
                    ),
                  ])
                ])
              ],
            ),
          );
        },
      ),
    );

    // Save the PDF document to bytes
    final pdfBytes = await pdf.save();

    // Create a Blob object from the Excel file bytes
    final blob = Blob([Uint8List.fromList(pdfBytes)]);
    final url = Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final anchor = AnchorElement(href: url);
    anchor.download = 'invoice.pdf';
    anchor.text = 'Click here to download the Excel file';

    // Add the download link to the body and trigger the download
    document.body!.append(anchor);
    anchor.click();

    // Clean up: remove the download link from the body
    anchor.remove();

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('PDF Generated'),
        content: Text(
            'The invoice PDF has been generated and downloaded successfully.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool isLoadingFullScreen=false;
}
