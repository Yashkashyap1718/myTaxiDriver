import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String dateMonthYear() {
    return DateFormat("dd MMMM yyyy").format(this);
  }
}
