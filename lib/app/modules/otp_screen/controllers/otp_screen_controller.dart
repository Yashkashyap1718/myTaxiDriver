// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class OtpScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxString otp = ''.obs;

  Future<bool> startBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.bookingStatus = BookingStatus.bookingOngoing;
    bookingModel.updateAt = Timestamp.now();
    bookingModel.pickupTime = Timestamp.now();
    bool? isStarted = await FireStoreUtils.setBooking(bookingModel);
    ShowToastDialog.showToast("Your ride started....");
    UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.customerId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.id};

    await SendNotification.sendOneNotification(
        type: "order",
        token: receiverUserModel!.fcmToken.toString(),
        title: 'Your Ride is Started',
        customerId: receiverUserModel.id,
        senderId: FireStoreUtils.getCurrentUid(),
        bookingId: bookingModel.id.toString(),
        driverId: bookingModel.driverId.toString(),
        body: 'Your Ride is Started From ${bookingModel.pickUpLocationAddress.toString()} to ${bookingModel.dropLocationAddress.toString()}.',
        payload: playLoad);

    // Get.offAll(const HomeView());
    return (isStarted ?? false);
  }
}
