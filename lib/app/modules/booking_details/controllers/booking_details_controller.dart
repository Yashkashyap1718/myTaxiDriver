// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/map_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingDetailsController extends GetxController {
  RxString bookingId = ''.obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;

  getBookingDetails() async {
    bookingModel.value = (await FireStoreUtils.getRideDetails(bookingId.value))!;
  }

  Future<String> getDistanceInKm() async {
    String km = '';
    LatLng departureLatLong = LatLng(bookingModel.value.pickUpLocation!.latitude ?? 0.0, bookingModel.value.pickUpLocation!.longitude ?? 0.0);
    LatLng destinationLatLong = LatLng(bookingModel.value.dropLocation!.latitude ?? 0.0, bookingModel.value.dropLocation!.longitude ?? 0.0);
    MapModel? mapModel = await Constant.getDurationDistance(departureLatLong, destinationLatLong);
    if (mapModel != null) {
      print("KM : ${mapModel.toJson()}");
      km = mapModel.rows!.first.elements!.first.distance!.text!;
    }
    return km;
  }

  Future<bool> completeBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingCompleted;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.dropTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setBooking(bookingModel);
    ShowToastDialog.showToast("Your ride is completed....");

    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};

    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Your Ride is Completed',
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        bookingId: bookingModel.id.toString(),
        driverId: bookingModel.driverId.toString(),
        body: 'Your ride has been successfully completed. Please take a moment to review your experience.',
        payload: playLoad);

    // Get.offAll(const HomeView());
    return (isStarted ?? false);
  }
}
