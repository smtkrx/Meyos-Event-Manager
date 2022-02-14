import 'package:event_manager/fonts/fonts.dart';
import 'package:event_manager/fonts/size.dart';
import 'package:event_manager/samples/group.dart';
import 'package:event_manager/samples/event.dart';
import 'package:event_manager/vendors/database_helper.dart';
import 'package:event_manager/vendors/events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../times/time.dart' as func;

class CreateNewEvent extends StatefulWidget {
  static const routeName = 'create-new-event';
  @override
  _CreateNewEventState createState() => _CreateNewEventState();
}
//A Class has been created to create a new event.
class _CreateNewEventState extends State<CreateNewEvent> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime, _endTime;
  String _eventName;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Group _value;

  Future<void> _selectDate() async {

    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      //Uploaded until a later date, starting from the date found.
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        //To set the selected day to that day's date.
        _selectedDate = pickedDate;
      });
  }

  void _selectTime() async {
//Date selection function
    TimeRange result = await showTimeRangePicker(
      use24HourFormat: false,
      //Added one image for Background
      backgroundWidget: Image.asset(
        "assets/images/clock.png",
        height: 200,
        width: 200,
      ),
      strokeWidth: 4,
      ticks: 24,
      ticksOffset: -7,
      ticksLength: 15,
      ticksColor: Colors.grey,
//For the selection of the hours of the day to be active.
      labels: ["12.00 am", "3.00 am", "6.00 am", "9.00 am", "12.00 pm", "3.00 pm", "6.00 pm", "9.00 pm"]
          .asMap()
          .entries
          .map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      context: context,
    );
    setState(() {
      _endTime = result.endTime;
      _startTime = result.startTime;
    });
  }
  //To save the entered form
  void saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    try {
      var event = Event(
        //To assign the defined event properties
        title: _eventName,
        date: _selectedDate,
        startTime: _startTime,
        endTime: _endTime,
        club: _value,
      );
      //Retrieved to add to database.
      final id = await DatabaseHelper.instance.insert(event.toMap());
      print(id);
      Provider.of<Events>(context, listen: false).addEvent(event.addId(id));
      //Written to the screen where the event is added
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event Added Successfully")));
    } catch (error) {
      print(error);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }
  bool isToggle = true;
  @override
  Widget build(BuildContext context) {
    final eventData = Provider.of<Events>(context, listen: false);
    return Material(
      child: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Icon defined to come back from the page
                        IconButton(
                          padding: EdgeInsets.all(0),
                          alignment: Alignment.centerLeft,
                          iconSize: SizeConfig.horizontalBlockSize * 7,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Create \nNew Event',
                          textAlign: TextAlign.start,
                          style: MyFonts.extraBold.size(
                            SizeConfig.horizontalBlockSize * 10,
                          ),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          cursorHeight: 28,
                          cursorColor: Colors.grey[400],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            hintStyle: TextStyle(color: Colors.grey),
                            focusColor: Colors.grey[800],
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade800,
                              ),
                            ),
                            hintText: 'Event Name',
                          ),
                          onSaved: (value) {
                            _eventName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Event name cannot be Empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: _selectDate,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    border: Border.all(
                                      color: Colors.green.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  DateFormat("EEEE d, MMMM")
                                      .format(_selectedDate),
                                  style: MyFonts.bold
                                      .size(SizeConfig.horizontalBlockSize * 5)
                                      .setColor(Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: _selectTime,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    border: Border.all(
                                      color: Colors.green.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  //An icon is defined to select the event time
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                SizedBox(width: 30),
                                Text(
                                  (_startTime == null && _endTime == null)
                                      ? "Select Time Range"
                                      : "${func.hours(_startTime)} : ${func.minutes(_startTime)} ${func.timeMode(_startTime)} - ${func.hours(_endTime)} : ${func.minutes(_endTime)} ${func.timeMode(_endTime)}",
                                  style: MyFonts.bold
                                      .size(SizeConfig.horizontalBlockSize * 5)
                                      .setColor(Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    border: Border.all(
                                      color: Colors.blue.shade100,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  //An icon is defined to select the event club
                                  child: Icon(
                                    Icons.category,
                                    color: Colors.blue.shade400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 20,
                                  ),
                                  child: DropdownButton<Group>(
                                    hint: Text(
                                      "Select a club",
                                      style: MyFonts.medium.size(17),
                                    ),
                                    // isExpanded: true,

                                    items:
                                        eventData.categories.map((Group item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item.title,
                                          style: MyFonts.medium.size(
                                              SizeConfig.horizontalBlockSize *
                                                  5),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    },
                                    value: _value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        border: Border.all(
                                          color: Colors.red.shade100,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                            Icons.notifications_none_outlined),
                                        onPressed: () {},
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Remind Me", style: MyFonts.medium.size(18),
                                      ),
                                    ),
                                  ],
                                ),
                                //A button has been defined to receive a notification message when the event will start.
                                IconButton(
                                  onPressed: () {
                                    setState(() {isToggle = !isToggle;});},
                                  icon: isToggle == false
                                      ? Icon(
                                          Icons.toggle_on,
                                          color: Colors.blue[900],
                                        )
                                      : Icon(Icons.toggle_off),
                                  iconSize: 60,
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: saveForm,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900],
                              padding: EdgeInsets.symmetric(
                                horizontal: 115,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            //Create event button defined
                            child: Text('CREATE EVENT',
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
