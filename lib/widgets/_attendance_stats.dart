import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceStatsWidget extends StatefulWidget {
  const AttendanceStatsWidget({super.key});

  @override
  State<AttendanceStatsWidget> createState() => _AttendanceStatsWidgetState();
}

class _AttendanceStatsWidgetState extends State<AttendanceStatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40,top: 20,bottom: 10,right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Statistics',style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),),
            ],
          ),
        ),
        const SizedBox(height: 10,),


        //today stats
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today:'),
                        Text('5 hours')
                      ],
                    ),
                    const SizedBox(height: 10,),
                    LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10,),
              //today stats
              Container(
                margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('This Week:'),
                        Text('37 hours')
                      ],
                    ),
                    const SizedBox(height: 10,),
                    LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              //this month stats
              Container(
                margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('This Month:'),
                        Text('150 hours')
                      ],
                    ),
                    const SizedBox(height: 10,),
                    LinearProgressIndicator(
                      value: 0.8,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
