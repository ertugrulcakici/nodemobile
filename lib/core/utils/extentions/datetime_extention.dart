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
}
