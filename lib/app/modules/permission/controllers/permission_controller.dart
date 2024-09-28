// ignore_for_file: unnecessary_overrides

import 'dart:io';

import 'package:get/get.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:location/location.dart';

class PermissionController extends GetxController {
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

  updatePermissions() async {
    Location location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (Platform.isAndroid) {
        location.enableBackgroundMode(enable: true).then((value) {
        if (value) {
          Get.to(const HomeView());
        } else {
          ShowToastDialog.showToast("Please enable background mode");
        }
      });
      } else {
        Get.to(const HomeView());
      }

    } else {
      location.requestPermission().then((permissionStatus) {
        if (permissionStatus == PermissionStatus.granted) {
          if (Platform.isAndroid) {
            location.enableBackgroundMode(enable: true).then((value) {
            if (value) {
              Get.to(const HomeView());
            } else {
              ShowToastDialog.showToast("Please enable background mode");
            }
          });
          } else {
            Get.to(const HomeView());
          }

        }
      });
    }
    update();
  }
}
