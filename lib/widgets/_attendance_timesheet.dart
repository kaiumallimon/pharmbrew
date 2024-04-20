import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AttendanceTimeSheet extends StatefulWidget {
  const AttendanceTimeSheet({super.key});

  @override
  State<AttendanceTimeSheet> createState() => _AttendanceTimeSheetState();
}

class _AttendanceTimeSheetState extends State<AttendanceTimeSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40,top: 20,bottom: 10,right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Timesheet',style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),),
            ],
          ),
        ),
        const SizedBox(height: 10,),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),

          margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Check In at:',style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                        const SizedBox(height: 10,),
                        Text('10:00 AM',style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                        ),)
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Checked Out at:',style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                        const SizedBox(height: 10,),
                        Text('Yet to check out',style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                        ),)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),

        Container(
          width: double.infinity,
          height: 300,
          // color: Colors.red,
          margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SfRadialGauge(
                axes: <RadialAxis>[

                  RadialAxis(
                    showAxisLine: true,
                    // showLabels: false,
                    showTicks: false,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 8,
                      color: Color(0xFF003366),
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    minimum: 0,
                    maximum: 15,

                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 15,
                          color: Colors.teal,
                          startWidth: 0.1,
                          endWidth: 0.1),
                    ],

                    pointers: const <GaugePointer> [
                       NeedlePointer(
                        value: 5,
                        enableAnimation: true,
                        needleColor: Colors.black,
                        needleStartWidth: 1,
                        needleEndWidth: 5,
                        needleLength: 0.8,
                        knobStyle: KnobStyle(
                          knobRadius: 0.08,
                          sizeUnit: GaugeSizeUnit.factor,
                          borderColor: Colors.black,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                    annotations: const  <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '5 hours',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  )
                ],
              ),
              // Progress of time text
              // Positioned.fill(
              //   child: Center(
              //     child: TimeProgress(),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
// class TimeProgress extends StatelessWidget {
//   // Start time
//   final DateTime startTime = DateTime(2024, 4, 20, 10, 0); // Example: 10:00 AM
//
//   @override
//   Widget build(BuildContext context) {
//     // Current time
//     DateTime currentTime = DateTime.now();
//
//     // Calculate the time difference
//     Duration timeDifference = currentTime.difference(startTime);
//
//     // Calculate hours from the difference
//     int hoursPassed = timeDifference.inHours;
//
//     return Text(
//       'Time Passed: $hoursPassed hours',
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     );
//   }
// }