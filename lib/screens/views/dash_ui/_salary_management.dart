import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmbrew/utils/_show_dialog.dart';

class SalaryManagement extends StatefulWidget {
  const SalaryManagement({super.key});

  @override
  State<SalaryManagement> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<SalaryManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: const Row(
                children: [
                  Text(
                    'Payroll Management',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //header panel:

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(2, 2),
                              blurRadius: 3.0),
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(-1, -1),
                              blurRadius: 3.0)
                        ]),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.data_exploration_rounded,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Generate Financial Report',
                                style: GoogleFonts.inter(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Automate payroll calculations and generate comprehensive salary reports effortlessly with our virtual assistant',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              MouseRegion(
                                onEnter: (event) {
                                  setState(() {
                                    isHoveringGenerateReportButton = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    isHoveringGenerateReportButton = false;
                                  });
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    showCustomErrorDialog(
                                        'This Feature is not implemented yet!',
                                        context);
                                  },
                                  child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: isHoveringGenerateReportButton
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .tertiary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0, 2),
                                                blurRadius: 3.0)
                                          ]),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Generate Report',
                                              style: GoogleFonts.poppins(
                                                  color:
                                                      isHoveringGenerateReportButton
                                                          ? Colors.black
                                                          : Colors.white),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 3.0)
                        ]),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Monthly Payroll',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'BDT 8491245.75',
                                  style: GoogleFonts.inter(
                                    fontWeight:FontWeight.bold,
                                    fontSize:25,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 3.0)
                        ]),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color:
                                        Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Company Expenses',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'BDT 32491245.75',
                                      style: GoogleFonts.inter(
                                        fontWeight:FontWeight.bold,
                                        fontSize:25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHoveringMonthButton = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHoveringMonthButton = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            showCustomErrorDialog(
                                'This Feature is not implemented yet!',
                                context);
                          },
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: isHoveringMonthButton
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0)
                                  ]),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text('Select Month',
                                        style: GoogleFonts.poppins(
                                            color: isHoveringMonthButton
                                                ? Colors.black
                                                : Colors.black)),
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHoveringSortButton = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHoveringSortButton = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            showCustomErrorDialog(
                                'This Feature is not implemented yet!',
                                context);
                          },
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: isHoveringSortButton
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0)
                                  ]),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.sort_rounded,
                                      color: isHoveringSortButton
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        isHoveringPaymentButton = true;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        isHoveringPaymentButton = false;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        showCustomErrorDialog(
                            'This Feature is not implemented yet!', context);
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: isHoveringPaymentButton
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 2),
                                    blurRadius: 3.0)
                              ]),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_card_rounded,
                                  color: isHoveringPaymentButton
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add New Payment',
                                  style: GoogleFonts.poppins(
                                      color: isHoveringPaymentButton
                                          ? Colors.black
                                          : Colors.white),
                                )
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 3.0)
                  ]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 30, bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 400,
                          child: Text(
                            'Employee',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 250,
                          child: Text(
                            'Payment Date',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 200,
                          child: Text(
                            'Payment Amount',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 200,
                          child: Text(
                            'Payment Method',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 250,
                          child: Text(
                            'Status',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          width: 250,
                          child: Text(
                            'Action',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 400,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRPGIpNsJ-lJpFoQ21Vv-vRmd9eh0ym-jUrVrcukhooQ&s',
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Kaium Al Limon',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 250,
                                child: Text(
                                  '12/12/2021',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 200,
                                child: Text(
                                  '1000',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 200,
                                child: Text(
                                  'Bank Transfer',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 250,
                                child: Text(
                                  'Pending',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                alignment: Alignment.center,
                                width: 250,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_horiz))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }

  bool isHoveringPaymentButton = false;
  bool isHoveringSortButton = false;
  bool isHoveringMonthButton = false;
  bool isHoveringGenerateReportButton = false;
}
