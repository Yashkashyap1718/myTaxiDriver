import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String dateMonthYear() {
    return DateFormat("dd MMM, yyyy").format(this);
  }

  String time() {
    return DateFormat("hh:mm a").format(this);
  }

  String displayDate() {
    return DateFormat("dd MMM, yyyy HH:mm:ss a ").format(this);
  }

  String displayDateMonth() {
    return DateFormat("dd MMM").format(this);
  }

  String displayMonthDate() {
    return DateFormat("MMM dd").format(this);
  }

  String bookingDateDisplay() {
    return DateFormat("dd MMM E, yy").format(this);
  }
}
