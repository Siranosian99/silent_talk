import 'package:intl/intl.dart';

String formatTimeWithSeconds(DateTime time) {
  final formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');
  return formatter.format(time);
}
String lastSeenFormat(DateTime dateTime) {
  String date = DateFormat('yyyy-MM-dd').format(dateTime); // 📅 2025-10-01
  String time = DateFormat('HH:mm').format(dateTime);      // ⏰ 14:35
  return "$date\n$time"; // put date on first line, time on second
}

