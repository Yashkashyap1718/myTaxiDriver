import 'dart:ui';

class BookingStatus {
  static const String bookingPlaced = "booking_placed";
  static const String bookingAccepted = "booking_accepted";
  static const String bookingOngoing = "booking_ongoing";
  static const String bookingCancelled = "booking_cancelled";
  static const String bookingCompleted = "booking_completed";
  static const String bookingRejected = "booking_rejected";

  static String getBookingStatusTitle(String status) {
    String bookingStatus = '';
    if (status == bookingPlaced) {
      bookingStatus = 'Placed';
    } else if (status == bookingAccepted) {
      bookingStatus = 'Accepted';
    } else if (status == bookingOngoing) {
      bookingStatus = 'Ongoing';
    } else if (status == bookingCancelled) {
      bookingStatus = 'Cancelled';
    } else if (status == bookingCompleted) {
      bookingStatus = 'Completed';
    } else if (status == bookingRejected) {
      bookingStatus = 'Rejected';
    }
    return bookingStatus;
  }

  static Color getBookingStatusTitleColor(String status) {
    Color color = const Color(0xff9d9d9d);
    if (status == bookingPlaced) {
      color = const Color(0xff9d9d9d);
    } else if (status == bookingAccepted) {
      color = const Color(0xff1EADFF);
    } else if (status == bookingOngoing) {
      color = const Color(0xffD19D00);
    } else if (status == bookingCancelled) {
      color = const Color(0xffFE7235);
    } else if (status == bookingCompleted) {
      color = const Color(0xff27C041);
    } else if (status == bookingRejected) {
      color = const Color(0xffFE7235);
    }
    return color;
  }
}
