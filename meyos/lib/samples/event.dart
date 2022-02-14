import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager/samples/group.dart';
import 'package:flutter/material.dart';


extension passTime on TimeOfDay {
  String toExtractableString() {
    //We use it to retrieve the data that we have saved in the local database
    return json.encode({
      'hour': this.hour,
      'minute': this.minute,
    });
  }
}

class Event {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ev = FirebaseFirestore.instance.collection('Events');
  //The id variable is the primary key and helps to find the activity to be returned easily.
  final int id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Group club;

  Event({
    //Sub-function of event class named event
    this.id,
    this.title,
    this.date,
    this.startTime,
    this.endTime,
    this.club,
  });

  Map<String, dynamic> toMap() {
    ev.add({'Event Name':'$title','Date':'$date'
      ,'Start Time':'$startTime','Finish Time':'$endTime'});
    return {
      //The time of the event etc. to get
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime.toExtractableString(),
      'endTime': endTime.toExtractableString(),
      'club': json.encode({
        'title': club.title,
        'color': club.color.value,
      })
    };
  }
  Event addId(int id) {
    return Event(
      //When an event is added, it maps the event's information to the entered event information
      id: id,
      title: this.title,
      date: this.date,
      startTime: this.startTime,
      endTime: this.endTime,
      club: this.club,
    );
  }
  factory Event.fromMap(Map<String, dynamic> map) {
    final startTimeData = json.decode(map['startTime']) as Map<String, dynamic>;
    final endTimeData = json.decode(map['endTime']) as Map<String, dynamic>;
    final clubData = json.decode(map['club']);
    return Event(
      //Returns the event's information on all events page
        id: map['id'],
        title: map['title'],
        date: DateTime.parse(map['date']),
        startTime: TimeOfDay(
            hour: startTimeData['hour'], minute: startTimeData['minute']),
        endTime:
            TimeOfDay(hour: endTimeData['hour'], minute: endTimeData['minute']),
        club: Group(
          title: clubData['title'],
          color: Color(clubData['color']),
        ),
    );
  }
}
