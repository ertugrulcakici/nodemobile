// ignore_for_file: non_constant_identifier_names

extension DateTimeExtention on DateTime {
  String get D {
    return '$year-$month-$day';
  }

  String get DT {
    return '$D $T';
  }

  String get T {
    return '$hour:$minute:$second';
  }
}
