import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:pharmbrew/domain/_add_products.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/widgets/_add_product_fields.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../domain/_fetch_products.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool isLoading = true; // Flag to track loading state

  List<String> dataTableColumns = [
    'Product ID',
    'Product Name',
    'Variant',
    'Production Date',
    'Expiry Date',
    'Unit Per Strips',
    'Unit Price',
    'Stock',
  ];

  List<List<String>> allProducts = [];
  List<List<String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    fetchProductsLocal(allProducts);
  }

  void fetchProductsLocal(List<List<String>> allProductsList) async {
    try {
      allProductsList.clear();

      List<dynamic> productsList = await fetchProducts();
      print(productsList);

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
        filteredData = List.from(allProductsList); // Initialize filteredData
        isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        isLoading = false; // Set loading state to false in case of error too
      });
    }
  }

  bool isExpanded = false;

  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(allProducts);
      } else {
        filteredData = allProducts.where((row) {
          for (var cell in row) {
            if (cell.toLowerCase().contains(query.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();
      }
    });
  }

  void exportExcel() {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];

    // Write headers
    for (var i = 0; i < dataTableColumns.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(dataTableColumns[i]);
    }

    // Write data rows
    for (var i = 0; i < filteredData.length; i++) {
      final row = filteredData[i];
      for (var j = 0; j < row.length; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(row[j]);
      }
    }

    final List<int> excelBytes = workbook.saveAsStream();
    workbook.dispose();

    // Create a Blob object from the Excel file bytes
    final blob = Blob([Uint8List.fromList(excelBytes)]);
    final url = Url.createObjectUrlFromBlob(blob);

    // Create a download link
    final anchor = AnchorElement(href: url);
    anchor.download = 'products.xlsx';
    anchor.text = 'Click here to download the Excel file';

    // Add the download link to the body and trigger the download
    document.body!.append(anchor);
    anchor.click();

    // Clean up: remove the download link from the body
    anchor.remove();
  }

  DateTime productionDate = DateTime.now();
  DateTime expiryDate = DateTime.now();
  bool selected1 = false;
  bool selected2 = false;

  Future<DateTime?> _selectDate(BuildContext context, DateTime dateTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030),
    );
    return picked;
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productVariantController = TextEditingController();
  TextEditingController productUnitPerStripsController = TextEditingController();
  TextEditingController productUnitPriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if data is loading
          : Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    //header
                    Text(
                      'Products',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              filterData(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search Products',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // reload button
                        Container(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  fetchProductsLocal(allProducts);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.refresh),
                                  const SizedBox(width: 5),
                                  Text('Refresh'),
                                ],
                              )),
                        ),

                        SizedBox(width: 20),

                        //add new product button
                        Container(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: Text('Add New Product')),
                        ),

                        SizedBox(width: 20),

                        //export as csv button
                        Container(
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                exportExcel();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: Text('Export As CSV')),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    Theme.of(context).colorScheme.primary),
                            headingTextStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                            ),
                            columns: [
                              for (var column in dataTableColumns)
                                DataColumn(label: Text(column))
                            ],
                            rows: [
                              for (var row in filteredData)
                                DataRow(cells: [
                                  for (var cell in row) DataCell(Text(cell))
                                ])
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        isExpanded
                            ? Container(
                                width: 500,
                                child: Column(
                                  children: [
                                    //header
                                    Container(
                                      height: 55,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Row(children: [
                                        Expanded(
                                            child: Center(
                                          child: Text(
                                            'Add New Product',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                        Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isExpanded = false;
                                                selected1 = false;
                                                selected2 = false;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                    const SizedBox(height: 20),

                                    //body
                                    AddProductFields(
                                        controller: productNameController,
                                        labelText: 'Product Name'),
                                    const SizedBox(height: 20),
                                    AddProductFields(
                                        controller: productVariantController,
                                        labelText: 'Product Variant'),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                DateTime? pickedDate =
                                                    await _selectDate(context,
                                                        productionDate);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    productionDate = pickedDate;
                                                    selected1 = true;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child: !selected1
                                                  ? const Text(
                                                      'Production Date')
                                                  : Text(
                                                      "${productionDate.toLocal()}"
                                                          .split(' ')[0]),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                DateTime? pickedDate =
                                                    await _selectDate(
                                                        context, expiryDate);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    expiryDate = pickedDate;
                                                    selected2 = true;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child: !selected2
                                                  ? const Text('Expiry Date')
                                                  : Text(
                                                      "${expiryDate.toLocal()}"
                                                          .split(' ')[0]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    AddProductFields(
                                        controller:
                                            productUnitPerStripsController,
                                        labelText: 'Unit Per Strips'),
                                    const SizedBox(height: 20),
                                    AddProductFields(
                                        controller: productUnitPriceController,
                                        labelText: 'Unit Price'),
                                    const SizedBox(height: 20),
                                    AddProductFields(
                                        controller: productStockController,
                                        labelText: 'Stock'),
                                    const SizedBox(height: 20),
                                    //footer
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          height: 50,
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                String productName =
                                                    productNameController.text.toString();
                                                String variant =
                                                    productVariantController
                                                        .text.toString();
                                                String prodDate =
                                                    productionDate.toString();
                                                String unitPrice =
                                                    productUnitPriceController
                                                        .text;
                                                String expDate =
                                                    expiryDate.toString();
                                                String quantity =
                                                    productStockController.text.toString();
                                                String unitPerStrips =
                                                    productUnitPerStripsController
                                                        .text.toString();

                                                bool? result = await addProduct(
                                                  productName: productName,
                                                  variant: variant,
                                                  productionDate: prodDate,
                                                  unitPrice: unitPrice,
                                                  expDate: expDate,
                                                  quantity: quantity,
                                                  unitPerStrips: unitPerStrips,
                                                );

                                                if (result == true) {
                                                  setState(() {
                                                    productNameController
                                                        .clear();
                                                    productVariantController
                                                        .clear();
                                                    productUnitPerStripsController
                                                        .clear();
                                                    productUnitPriceController
                                                        .clear();
                                                    productStockController
                                                        .clear();
                                                    selected1 = false;
                                                    selected2 = false;

                                                    fetchProductsLocal(allProducts);

                                                    showCustomSuccessDialog("Product added!", context);

                                                  });
                                                }else{
                                                  showCustomErrorDialog('Failed to add product!', context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              child: Text('Add Product')),
                                        ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
