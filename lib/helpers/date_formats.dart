import 'package:intl/intl.dart';

class DateFormats {
  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    final String formattedTime = formatter.format(dateTime);
    return formattedTime;
  }
}
