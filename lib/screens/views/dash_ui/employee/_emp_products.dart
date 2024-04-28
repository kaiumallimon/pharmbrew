import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pharmbrew/data/_delete_product.dart';
import 'package:pharmbrew/domain/_add_products.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';
import 'package:pharmbrew/widgets/_add_product_fields.dart';
import 'package:pharmbrew/widgets/_successful_dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'package:flutter/material.dart';

import '../../../../domain/_fetch_products.dart';


class EmployeeProducts extends StatefulWidget {
  const EmployeeProducts({Key? key}) : super(key: key);

  @override
  State<EmployeeProducts> createState() => _ProductsState();
}

class _ProductsState extends State<EmployeeProducts> {
  bool isLoading = true; // Flag to track loading state

  List<String> dataTableColumns = [
    'Product Name',
    'Variant',
    'Production Date',
    'Expiry Date',
    'Unit Per Strips',
    'Unit Price',
    'Stock',
  ];

  List<List<String>> allProducts = [];
  List<List<String>> allExpiredProducts = [];
  List<List<String>> filteredData = [];
  List<List<String>> filteredDataExpired = [];

  late Timer timer1;

  @override
  void initState() {
    super.initState();
    fetchProductsLocal(allProducts);
    fetchProductsLocalExpired(allExpiredProducts);
  }

  @override
  void dispose() {
    timer1.cancel();
    super.dispose();
  }

  bool isProductExpired(String expiryDateString) {
    DateTime expiryDate = DateTime.parse(expiryDateString);
    DateTime currentDate = DateTime.now();
    return currentDate.isAfter(expiryDate);
  }

  void fetchProductsLocal(List<List<String>> allProductsList) async {
    try {
      allProductsList.clear();

      List<dynamic> productsList = await fetchProducts();

      setState(() {
        for (var product in productsList) {

          if(!isProductExpired(product['expDate'])){
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
        }
        filteredData = List.from(allProductsList); // Initialize filteredData
        isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading state to false in case of error too
      });
    }
  }



  void fetchProductsLocalExpired(List<List<String>> allProductsList) async {
    try {
      allExpiredProducts.clear();

      List<dynamic> productsList = await fetchProducts();

      setState(() {
        for (var product in productsList) {
          if (isProductExpired(product['expDate'])) {
            List<String> productData = [];
            productData.add(product['product_id']);
            productData.add(product['productName']);
            productData.add(product['variant']);
            productData.add(product['productionDate']);
            productData.add(product['expDate']);
            productData.add(product['unitPerStrips']);
            productData.add(product['unitPrice']);
            productData.add(product['quantity']);
            allExpiredProducts.add(productData);
          }
        }
        filteredDataExpired = List.from(allExpiredProducts); // Initialize filteredDataExpired correctly
        isLoading = false; // Set loading state to false after data is fetched

        // allExpiredProducts.sort((a, b) {
        //   // Convert expDate strings to DateTime objects for comparison
        //   DateTime dateA = DateTime.parse(a[4]); // assuming the expiration date is at index 4
        //   DateTime dateB = DateTime.parse(b[4]);
        //
        //   // Compare dates in descending order
        //   return dateB.compareTo(dateA);
        // });

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

  void filterExpiredData(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDataExpired = List.from(allExpiredProducts);
      } else {
        filteredDataExpired = allExpiredProducts.where((row) {
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


  void exportExcel(List<List<String>> data) {
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];

    // Write headers
    for (var i = 0; i < dataTableColumns.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(dataTableColumns[i]);
    }

    // Write data rows
    for (var i = 0; i < data.length; i++) {
      final row = data[i];
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
  TextEditingController searchController2 = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productVariantController = TextEditingController();
  TextEditingController productUnitPerStripsController =
  TextEditingController();
  TextEditingController productUnitPriceController = TextEditingController();
  TextEditingController productStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
          child:
          CircularProgressIndicator()) // Show loading indicator if data is loading
          : Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              //header
              const Text(
                'Products',
                style:
                TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),


              Container(
                padding: const EdgeInsets.only(bottom: 20),
                color: Colors.white,
                child: Row(children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        inFocusTab = 0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 200,
                      alignment: Alignment.center,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: inFocusTab == 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Active Products',
                        style: TextStyle(
                          color: inFocusTab == 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        inFocusTab = 1;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      width: 250,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: inFocusTab == 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Expired Products',
                        style: TextStyle(
                          color: inFocusTab == 1 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ]),
              ),


              inFocusTab==0?Column(
                children: [
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
                          decoration: const InputDecoration(
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
                      SizedBox(
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
                            child: const Row(
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(width: 5),
                                Text('Refresh'),
                              ],
                            )),
                      ),

                      // const SizedBox(width: 20),
                      //
                      // //add new product button
                      // SizedBox(
                      //   height: 45,
                      //   child: ElevatedButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           isExpanded = true;
                      //         });
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.white,
                      //         foregroundColor: Colors.black,
                      //         side: BorderSide(
                      //             color:
                      //             Theme.of(context).colorScheme.primary),
                      //       ),
                      //       child: const Text('Add New Product')),
                      // ),

                      const SizedBox(width: 20),

                      //export as csv button
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {
                              exportExcel(filteredData);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color:
                                  Theme.of(context).colorScheme.primary),
                            ),
                            child: const Text('Export As CSV')),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 20),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('Active Products:',style: TextStyle(
                  //       color: Colors.grey.shade500
                  //     ),),
                  //     Text(
                  //       ' ${allProducts.length}',
                  //       style: TextStyle(
                  //         color: Theme.of(context).colorScheme.primary,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     )
                  //   ],
                  // ),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                              Theme.of(context).colorScheme.primary),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                          ),
                          columns: [
                            for (var column in dataTableColumns)
                              DataColumn(label: Text(column)),
                          ],
                          rows: [
                            for (var i = 0; i < filteredData.length; i++)
                              DataRow(cells: [
                                // Start the loop from j = 1 to skip the product ID at index 0
                                for (var j = 1; j < filteredData[i].length; j++)
                                  DataCell(Text(filteredData[i][j])),
                              ]),
                          ],

                        ),
                      ),
                      const SizedBox(width: 20),
                      isExpanded
                          ? SizedBox(
                        width: 500,
                        child: Column(
                          children: [
                            //header
                            Container(
                              height: 55,
                              color:
                              Theme.of(context).colorScheme.primary,
                              child: Row(children: [
                                const Expanded(
                                    child: Center(
                                      child: Text(
                                        'Add New Product',
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    )),
                                Container(
                                  margin:
                                  const EdgeInsets.only(right: 5),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = false;
                                        selected1 = false;
                                        selected2 = false;
                                      });
                                    },
                                    icon: const Icon(
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
                                  child: SizedBox(
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
                                  child: SizedBox(
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
                                labelText: 'Quantity'),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                          : Container()
                    ],
                  ),
                ],
              ):Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              filterExpiredData(value);
                            },
                            decoration: const InputDecoration(
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
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                fetchProductsLocalExpired(allExpiredProducts);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(width: 5),
                                Text('Refresh'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        //export as csv button
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              exportExcel(filteredDataExpired);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            child: const Text('Export As CSV'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            Expanded(child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Theme.of(context).colorScheme.primary,
                              ),
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                              ),
                              columns: [
                                for (var column in dataTableColumns)
                                  DataColumn(label: Text(column)),

                              ],
                              rows: [
                                for (var i = 0; i < filteredDataExpired.length; i++)
                                  DataRow(cells: [
                                    // Start the loop from j = 1 to skip the product ID at index 0
                                    for (var j = 1; j < filteredDataExpired[i].length; j++)
                                      DataCell(Text(filteredDataExpired[i][j])),
                                  ]),
                              ],
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  var inFocusTab=0;
}
