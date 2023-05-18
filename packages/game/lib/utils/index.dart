import 'package:intl/intl.dart';

parseDateTime(String dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime.parse(dateTime).add(const Duration(hours: 8)));
}
