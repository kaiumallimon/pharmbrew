import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/widgets/_add_product_fields.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/pdf.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
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
    fetchProductsLocal(allProducts);
    filteredData = List.from(allProducts); // Initialize filteredData
  }

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
          for (var cell in row) {
            if (cell.toLowerCase().contains(query.toLowerCase())) {
              suggestions.add('$cell - ${row[2]}');
              // variantNames.add(row[2]);
              return true;
            }
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
          child: ListView(
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
                        TextField(
                          onChanged: (value) {
                            filterData(value);
                            print(filteredData);

                            if (value.trim().isEmpty) {
                              setState(() {
                                quantityController.text = '0';
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
                                  color: Colors.grey.shade300, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Suggestions displayed below the text field
                        if (suggestions.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: suggestions
                                .map((suggestion) => ListTile(
                                      title: Text(suggestion),
                                      onTap: () {
                                        // You can do something when a suggestion is tapped
                                        // For example, you can set the text field value to the suggestion
                                        // nameController.text = suggestion;
                                        // print('Selected item: $suggestion');
                                        nameController.text = suggestion;
                                        setState(() {
                                          suggestions = [];
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                        suggestions.isNotEmpty
                            ? const SizedBox(
                                height: 15,
                              )
                            : const SizedBox.shrink(),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onLongPress: _startTimer2,
                                onLongPressUp: _stopTimer,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String text = quantityController.text;
                                      int quantity = int.parse(text);
                                      if (quantity > 0) {
                                        setState(() {
                                          quantityController.text =
                                              (quantity - 1).toString();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: const RoundedRectangleBorder(),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2),
                                    ),
                                    child: const Icon(Icons.remove),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AddProductFields(
                                controller: quantityController,
                                readOnly: true,
                                labelText: "Product Quantity",
                              ),
                            ),
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: const RoundedRectangleBorder(),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 2),
                                    ),
                                    child: const Icon(Icons.add),
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

                                    Map<String, dynamic> productInfo =
                                        getSelectedProuctInfo(
                                            nameController.text);
                                    cartItems.add(productInfo);
                                    print(cartItems);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2),
                                  ),
                                  child: const Icon(Icons.add),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
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
                        AddProductFields(
                          controller: customerNameController,
                          labelText: 'Customer Name',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AddProductFields(
                          controller: customerEmailController,
                          labelText: 'Customer Email',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AddProductFields(
                          controller: customerPhoneController,
                          labelText: 'Customer Phone',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AddProductFields(
                          controller: customerBillingController,
                          labelText: 'Billing Info',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      customerInfo['name'] =
                                          customerNameController.text;
                                      customerInfo['email'] =
                                          customerEmailController.text;
                                      customerInfo['phone'] =
                                          customerPhoneController.text;
                                      customerInfo['billing'] =
                                          customerBillingController.text;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2),
                                  ),
                                  child: const Icon(Icons.add),
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
                                          'Email: ${customerInfo['phone']}'),
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
                                    headingRowColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('Name')),
                                      DataColumn(label: Text('Variant')),
                                      DataColumn(label: Text('Quantity')),
                                      DataColumn(label: Text('Price')),
                                    ],
                                    rows: [
                                      // Your cart items
                                      for (var item in cartItems)
                                        DataRow(cells: [
                                          DataCell(Text(item['name'])),
                                          DataCell(Text(item['variant'])),
                                          DataCell(Text(item['quantity (strips)'])),
                                          DataCell(Text(item['price'].toString())),
                                        ]),
                                      // Extra row for total price
                                      DataRow(cells: [
                                        const DataCell(Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                        const DataCell(Text('')), // Variant column is empty for total price
                                        const  DataCell(Text('')), // Quantity column is empty for total price
                                         DataCell(
                                          Text(
                                            calculateTotalPrice(), // Call a function to calculate total price
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),

                                ),
                              ],
                            )
                            : Container(
                                height: 400,
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
                        onPressed: () {
                          generateAndSavePDF(customerInfo, cartItems);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
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

  String calculateTotalPrice(){
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item['price'];
    }
    return totalPrice.toString();
  }

  Future<void> generateAndSavePDF(Map<String, dynamic> invoiceData, List<Map<String, dynamic>> cartItems) async {
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
                pw.Text('Invoice', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                // Add invoice data from the map
                for (var entry in invoiceData.entries)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Receiver ${entry.key}: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                      [item['name'], item['variant'], item['quantity (strips)'], item['price'].toString()],
                  ],
                  border: pw.TableBorder.all(
                    color: PdfColors.grey,
                    width: 1,
                  ),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, ),
                  cellStyle: const pw.TextStyle(),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
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
        content: Text('The invoice PDF has been generated and downloaded successfully.'),
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

}
