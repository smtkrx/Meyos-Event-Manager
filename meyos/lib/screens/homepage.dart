import 'package:event_manager/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import './profile.dart';
import 'package:event_manager/screens/events_screen.dart';
import '../fonts/size.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topPadding = 0;

  bool isDrawerOpen = false;

  int _selectedIndex = 0;
  List<Widget> _screens = [EventScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
              child: Column(
                children: [
                  Container(
                    // color: kBlue,
                    padding: EdgeInsets.only(left: 5, top: topPadding),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isDrawerOpen
                              ? IconButton(
                            color: Colors.black,
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
                              : IconButton(
                                  color: Colors.black,
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
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            color: Colors.blue[900],
                            width: SizeConfig.horizontalBlockSize * 18,
                            height: double.infinity,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    CalendarScreen.routeName);
                              },
                              icon: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.white,
                                size: SizeConfig.verticalBlockSize * 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _screens[_selectedIndex],
                ],
              ),
            ),
            // _screens[_selectedIndex],
          ],
        ),
      ),
    );
  }
}
