import 'package:intl/intl.dart';

class DateFormats {
  static String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    final String formattedTime = formatter.format(dateTime.toLocal());
    return formattedTime;
  }

  static String formatDateTime(DateTime dateTime) {
    DateFormat formatter;
    if (dateTime.year == DateTime.now().year) {
      Duration difference = DateTime.now().difference(dateTime);
      int differenceInDays = difference.inDays;

      if (dateTime.day == DateTime.now().day) {
        formatter = DateFormat('HH:mm');
      } else if (differenceInDays < 7) {
        formatter = DateFormat('HH:mm, EEEE', 'vi_VN');
      } else {
        formatter = DateFormat('HH:mm dd \'THG\' MM', 'vi_VN');
      }
    } else {
      formatter = DateFormat('HH:mm dd-MM-yyyy ');
    }
    final String formattedTime = formatter.format(dateTime.toLocal());
    return formattedTime;
  }
}
