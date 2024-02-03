import 'package:flutter/widgets.dart';

class Terms_Policy extends StatelessWidget {
  const Terms_Policy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: const Column(children: [
        //first row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("By proceeding, you agree to the"),
            SizedBox(
              width: 5,
            ),
            Text(
              "Terms",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              width: 5,
            ),
            Text("and"),
            SizedBox(
              width: 5,
            ),
            Text("Privacy Policies",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),)
          ],
        ),
        SizedBox(height: 10,),
    
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home"),
            SizedBox(width: 10,),
            Text("Help"),
            SizedBox(width: 10,),Text("Terms"),
            SizedBox(width: 10,),Text("Privacy"),
            SizedBox(width: 10,)
          ],
        )
    
        //second row
      ]),
    );
  }
}
