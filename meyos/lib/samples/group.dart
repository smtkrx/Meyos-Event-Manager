import 'dart:ui';
import 'package:flutter/material.dart';

//A bar has been created so that the topics of the events can be distinguished more easily.
// This page is made for categorization.
class Group {
  //The club features of the events were defined.
  final int id;
  final String title;
  final IconData icon;
  final Color color;

  Group({
    this.id,
    this.title,
    this.icon,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      //Returned club information and color.
      'clubTitle': title,
      'color': color.value,
    };
  }

  Group addId(int id) {
    return Group(
      //Creating and assigning a new unique group
      id: id,
      title: this.title,
      color: this.color,
    );
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      //Finally, club variants are returned.
      id: map['id'],
      title: map['clubTitle'],
      color: Color(map['color']),
    );
  }
}
