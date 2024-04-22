import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodayActivityAttendance extends StatefulWidget {
  const TodayActivityAttendance({super.key});

  @override
  State<TodayActivityAttendance> createState() => _TodayActivityAttendanceState();
}

class _TodayActivityAttendanceState extends State<TodayActivityAttendance> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40,top: 20,bottom: 10,right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Today's activity",style: GoogleFonts.inter(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Text('Check-Out Time',style: GoogleFonts.inter(
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              Container(
                margin: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Text('Check-in Time',style: GoogleFonts.inter(
                    ),)
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
