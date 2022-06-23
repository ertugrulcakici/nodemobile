class DatetimeHelper {
  static DateTime fromDateString(String dateString) {
    List<String> date = dateString.split('-');
    return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
  }

  static DateTime fromTimeString(String timeString) {
    List<String> time = timeString.split(':');
    return DateTime(
        0, 0, 0, int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
  }

  static DateTime fromDateTimeString(String dateTimeString) {
    List<String> dateTime = dateTimeString.split(' ');
    List<String> date = dateTime[0].split('-');
    List<String> time = dateTime[1].split(':');
    return DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]),
        int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
  }
}
