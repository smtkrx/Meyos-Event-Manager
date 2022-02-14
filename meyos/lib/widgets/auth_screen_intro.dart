import 'package:flutter/material.dart';
import 'package:event_manager/fonts/size.dart';

//The login page of the application, as well as the Login page, was used to create a section at the top of this page.
class AuthScreenIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalBlockSize * 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          ////The application name is set to appear above the Login page.
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.20,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Text(
              "MEYOS",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 46),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            //A short motivational sentence to explain our application
            Text(
              "'The easy way to plan events...'",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
