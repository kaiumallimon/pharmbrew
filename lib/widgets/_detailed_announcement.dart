import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailedAnnouncement extends StatefulWidget {
  const DetailedAnnouncement({super.key, required this.title, required this.description, required this.publishDate, required this.start, required this.end, required this.publisher});

  final String title;
  final String description;
  final String publishDate;
  final String start;
  final String end;
  final String publisher;

  @override
  State<DetailedAnnouncement> createState() => _DetailedAnnouncementState();
}

class _DetailedAnnouncementState extends State<DetailedAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.of(context).size.height-100,
          width: MediaQuery.of(context).size.width-100,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close,color: Colors.red,))
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    height: 2,
                    width: MediaQuery.of(context).size.width-180,
                    color: Colors.grey,
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Event:',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  color:Colors.grey.shade500
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.start!=widget.end?'${widget.start} to ${widget.end}':'${widget.start}',
                              style: GoogleFonts.inter(
                              ),
                            ),
                          ],
                        ),

                        IconButton(onPressed: (){}, icon: Icon(Icons.print,size: 25,color: Colors.grey,)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    // padding: EdgeInsets.all(10),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                  ),
                  ),

                  const SizedBox(height: 40),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Published on:',
                          style: GoogleFonts.inter(
                            color:Colors.grey
                          ),
                        ),

                        const SizedBox(width: 3),
                        Text(
                          ' ${widget.publishDate}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 30),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('Published by: ',style: GoogleFonts.inter(color: Colors.grey),),
                  //     Text(widget.publisher,style: GoogleFonts.inter(fontWeight: FontWeight.bold),)
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        )
    ).frosted(
        blur: 20, borderRadius: BorderRadius.circular(10)
    );
  }
}

void showDetailedAnnouncement(BuildContext context, String title,
    String description, String publishDate, String start, String end, String publisher) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DetailedAnnouncement(
        title: title,
        description: description,
        publishDate: publishDate,
        start: start,
        end: end, publisher: publisher,
      );
    },
  );
}
