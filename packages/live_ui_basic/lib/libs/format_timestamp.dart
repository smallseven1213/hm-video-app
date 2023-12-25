import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formatter = DateFormat('HH:mm:ss');
  return formatter.format(date);
}
