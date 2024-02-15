import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmbrew/utils/_logout_util.dart';

class LogoutDashboard extends StatelessWidget {
  const LogoutDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: 50,
      // margin: EdgeInsets.only(left: 10,right: 10),
      child: Center(
        child: GestureDetector(
          onTap: (){
            logout(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.logout,color: Colors.black,size: 18,),
                SizedBox(width: 5,),
                Text("Logout",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
