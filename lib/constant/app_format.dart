import 'package:intl/intl.dart';

class AppFormat {
  static String createDateFullDay(DateTime originalDate) {
    final DateFormat formatter = DateFormat('EEEE, dd MM yyyy');
    return formatter.format(originalDate);
  }
}
