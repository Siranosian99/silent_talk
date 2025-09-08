import 'package:intl/intl.dart';

String formatTimeWithSeconds(DateTime time) {
  final formatter = DateFormat('hh:mm:ss a'); // hh = 12-hour, mm = minutes, ss = seconds, a = AM/PM
  return formatter.format(time);
}

