import 'package:event_manager/samples/event.dart';
import 'package:event_manager/vendors/database_helper.dart';
import 'package:flutter/material.dart';
import '../samples/group.dart';

extension DateOnlyCompare on DateTime {
  bool isDateBefore(DateTime other) {
    return this.year <= other.year &&
        this.month <= other.month &&
        this.day <= other.day;
  }

  bool isDateAfter(DateTime other) {
    return this.year >= other.year &&
        this.month >= other.month &&
        this.day >= other.day;
  }

  bool isDateSame(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}

class Events with ChangeNotifier {


  // ...........Code for handling categories...........
  DateTime selectedDate = DateTime.now();
  List<Group> _categories = [
    Group(
      title: "Sport Club",
      color: Colors.greenAccent,
    ),
    Group(
      title: "Chess Club",
      color: Colors.redAccent,
    ),
    Group(
      title: "Music Club",
      color: Colors.yellowAccent,
    ),
  ];

  List<Group> get categories {
    return [..._categories];
  }

  void addclub(Group grp) {
    if (!_categories.contains(grp)) {
      _categories.add(grp);
    }
    notifyListeners();
  }

  void fetchAndSetEvents() async {
    final List<Map<String, dynamic>> allEvents =
        await DatabaseHelper.instance.queryAll();
    final List<Map<String, dynamic>> allCategories =
        await DatabaseHelper.instance.queryAllCategories();
    allEvents.forEach((EventMap) {
      print(EventMap);
      _events.add(Event.fromMap(EventMap));
    });
    allCategories.forEach((catMap) {
      print(catMap);
      _categories.add(Group.fromMap(catMap));
    });
  }

  List<Event> _events = [];

  List<Event> get events {
    return [..._events];
  }

  List<Event> availableEvents(Group club) {
    List<Event> finalList = [];
    finalList = todaysEvent
        .where((event) => event.club.title == club.title)
        .toList();
    return finalList;
  }

  List<Event> get todaysEvent {
    List<Event> finalList = [];
    _events.forEach((event) {
      if (event.date.isDateSame(selectedDate)) {
        finalList.add(event);
      }
    });
    return finalList;
  }

  void addEvent(Event event) {
    if (!_events.contains(event)) {
      _events.add(event);
    }
    notifyListeners();
  }

  void changeSelectedDate(DateTime newDate) {
    selectedDate = newDate;
  }
}
