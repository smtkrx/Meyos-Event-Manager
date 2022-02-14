import 'package:event_manager/fonts/fonts.dart';
import 'package:event_manager/screens/calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './profile.dart';
import '../fonts/size.dart';

//Made for the properties of the calendar page.
class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendar-page';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topPadding = 0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // Stack widget creates a 3d space and places widgets on top of each other like a layer
      // So at the bottom would be the drawer screen and above that we will have the home screen in this case
      body: SafeArea(
        child: Stack(
          children: [
            ProfileScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                //A color suitable for the theme was chosen for the background of the calendar page.
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
              child: Column(
                children: [
                  Container(
                    //Top bar color adjusted
                    color: Colors.grey[400],
                    //The corners of the top bar have been adjusted.
                    padding: EdgeInsets.only(left: 5, top: topPadding),
                    child: IntrinsicHeight(
                      child: Stack(
                        children: [
                          isDrawerOpen
                              ? IconButton(
                            //Added a button to come back
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                      topPadding = 0;
                                    });
                                  },
                                )
                          //Added a button to reach the profile page
                              : IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    setState(() {
                                      xOffset =
                                          SizeConfig.horizontalBlockSize * 70;
                                      yOffset =
                                          SizeConfig.verticalBlockSize * 7;
                                      scaleFactor = 0.85;
                                      isDrawerOpen = true;
                                      topPadding = 15;
                                    });
                                  },
                                ),
                          Center(
                            child: Text(
                              DateFormat("dd MMMM ,yyyy")
                                  .format(DateTime.now()),
                              style: MyFonts.bold
                                  .size(SizeConfig.textScaleFactor * 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Calendar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
