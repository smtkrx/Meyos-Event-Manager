import 'package:event_manager/vendors/events.dart';
import 'package:event_manager/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  //A definition was made for the selected day and the previously specified day.
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          //Calendar definition is made and the size of the calendar is entered.
          focusedDay: selectedDay,
          firstDay: DateTime(2010),
          lastDay: DateTime(2030),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          //The starting day of the week was Monday
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekVisible: true,
          //To change the day
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            if (focusedDay == focusDay) {
              Provider.of<Events>(context, listen: false)
                  .changeSelectedDate(focusDay);
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            }
            setState(() {
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
            print(focusedDay);
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
          },
          //To style the Calendar
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              //Selected day background color set
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
              //The font color of the selected day is set
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              //Today background color set
              color: Colors.blue[900],
              //The shapes of the days in the calendar were determined.
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonShowsNext: false,
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(5.0),
            ),
            formatButtonTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.black,
          thickness: 0.25,
        ),
      ],
    );
  }
}
