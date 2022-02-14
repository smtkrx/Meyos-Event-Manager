//It was created to control the time information.
String timeMode(time) {
  //Returns null if no specific time is entered
  if (time == null) {
    return "";
  }
  //We split the day into two, before noon and in the afternoon.
  if (time.periodOffset == 0) {
    return " am";
  } else {
    return " pm";
  }
}
//Written function to get minutes
String minutes(time) {
  if (time == null) {
    return "";
  }
  if (time.minute < 10) {
    return "0${time.minute}";
  } else {
    return '${time.minute}';
  }
}
//Written function to get hours
String hours(time) {
  if (time == null) {
    return "";
  }
  if (time.hour - time.periodOffset == 0) {
    return '12';
  }
  return "${time.hour - time.periodOffset}";
}
