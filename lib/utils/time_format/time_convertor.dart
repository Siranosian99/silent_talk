import 'package:intl/intl.dart';

String formatTimeWithSeconds(DateTime time) {
  final formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');
  return formatter.format(time);
}

