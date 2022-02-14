import 'package:event_manager/fonts/fonts.dart';
import 'package:event_manager/fonts/size.dart';
import 'package:event_manager/samples/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../times/time.dart' as func;

class EventWidget extends StatelessWidget {
  final Event event;

  EventWidget(this.event);

  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 2.5),
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.only(right: 8, top: 8, left: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "${event.title}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: MyFonts.bold.size(18),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      DateFormat("d MMMM yy").format(event.date),
                      overflow: TextOverflow.ellipsis,
                      style: MyFonts.medium
                          .setColor(Colors.white)
                          .size(SizeConfig.horizontalBlockSize * 3),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      "${func.hours(event.startTime)}:${func.minutes(event.startTime)}${func.timeMode(event.startTime)} - ${func.hours(event.endTime)}:${func.minutes(event.endTime)}${func.timeMode(event.endTime)}",
                      overflow: TextOverflow.ellipsis,
                      style: MyFonts.medium
                          .setColor(Colors.white)
                          .size(SizeConfig.horizontalBlockSize * 3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
