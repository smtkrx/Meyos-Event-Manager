import 'package:event_manager/fonts/fonts.dart';
import 'package:event_manager/samples/group.dart';
import 'package:event_manager/vendors/events.dart';
import 'package:event_manager/screens/create_new_event.dart';
import 'package:event_manager/screens/edit_club_screen.dart';
import 'package:event_manager/widgets/club_button.dart';
import 'package:event_manager/widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fonts/size.dart';

//Page with all events
class EventScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double topPadding = 0;

  bool isDrawerOpen = false;

  //A button has been created to display all events.
  final Group allEventsCat = Group(
    icon: Icons.today_outlined,
    color: Colors.white,
  );
  Group currentCat;
  @override
  void initState() {
    //It is used to call the properties and methods of the superclass.
    super.initState();
    currentCat = allEventsCat;
  }
  @override
  Widget build(BuildContext context) {
    final eventData = Provider.of<Events>(context);
    //Using an expanded widget causes the child of a Row or Column to expand to fill the available space on the major axis.
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13),
            width: SizeConfig.horizontalBlockSize * 82,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      //Printed on the screen somewhat faintly
                      Text("EVENTS LIST",
                        style: MyFonts.medium
                            .setColor(Colors.grey)
                            .size(SizeConfig.horizontalBlockSize * 4),
                      ),
                      SizedBox(height: 6),
                      //Printed on the screen somewhat boldly
                      Text(
                        currentCat.title ?? "All Events",
                        style: MyFonts.bold
                            .size(SizeConfig.horizontalBlockSize * 8),
                      ),
                      SizedBox(height: 15),
                      if (currentCat == allEventsCat)
                        ...eventData.todaysEvent.map((event) {
                          return EventWidget(event);
                        }).toList(),
                      if (currentCat != allEventsCat)
                        ...eventData.availableEvents(currentCat).map((event) {
                          return EventWidget(event);
                        }).toList(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(CreateNewEvent.routeName),
                    child: Text(
                      "ADD NEW EVENT",
                      style: MyFonts.medium
                          .size(SizeConfig.horizontalBlockSize * 4),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 13),
                      primary: Colors.white,
                      backgroundColor: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: SizeConfig.horizontalBlockSize * 18,
            color: Colors.blue[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                clubButton(
                    Group(
                      icon: Icons.today_rounded,
                      color: Colors.white,
                    ), () {
                  setState(() {
                    currentCat = allEventsCat;
                  });
                }),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return clubButton(eventData.categories[index], () {
                        setState(() {
                          currentCat = eventData.categories[index];
                        });
                      });
                    },
                    itemCount: eventData.categories.length,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(EditclubScreen.routeName),
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: SizeConfig.verticalBlockSize * 4,
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
