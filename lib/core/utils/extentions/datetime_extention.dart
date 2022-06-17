extension DateTimeExtention on DateTime {
  String get dateString {
    return '$year-$month-$day';
  }

  String get dateAndTimeString {
    return '$dateString $timeString';
  }

  String get timeString {
    return '$hour:$minute:$second';
  }

  DateTime fromDateString(String dateString) {
    List<String> date = dateString.split('-');
    return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
  }

  DateTime fromTimeString(String timeString) {
    List<String> time = timeString.split(':');
    return DateTime(
        0, 0, 0, int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
  }

  DateTime fromDateTimeString(String dateTimeString) {
    List<String> dateTime = dateTimeString.split(' ');
    List<String> date = dateTime[0].split('-');
    List<String> time = dateTime[1].split(':');
    return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]),
        int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
  }
}
