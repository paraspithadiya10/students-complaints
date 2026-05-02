import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String dateFormat = 'd MMM yyyy';

  static String formatFromString(String rawDate) {
    final date = DateTime.parse(rawDate);
    return DateFormat(dateFormat).format(date);
  }
}
