import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  getNotification() async {
    isLoading.value = true;
    await FireStoreUtils.getNotificationList().then((value) {
      if (value != null) {
        notificationList.addAll(value);
      }
    });
    isLoading.value = false;
  }

  removeNotification(String id) async {
    await FirebaseFirestore.instance.collection(CollectionName.notification).doc(id).delete().then((value) {
      ShowToastDialog.showToast("Notification deleted successfully");
    }).catchError((error) {
      ShowToastDialog.showToast("Failed to delete notification, Try again after some time.");
    });
  }
}
