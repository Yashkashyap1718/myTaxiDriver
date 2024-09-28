import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/permission/views/permission_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/extension/string_extensions.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController countryCodeController = TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxInt selectedGender = 1.obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<DriverUserModel> userModel = DriverUserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.text = userModel.value.phoneNumber.toString();
        countryCodeController.text = userModel.value.countryCode.toString();
      } else {
        emailController.text = userModel.value.email.toString();
        nameController.text = userModel.value.fullName.toString();
      }
    }
    update();
  }

  createAccount() async {
    String fcmToken = await NotificationService.getToken();
    ShowToastDialog.showLoader("please_wait".tr);
    DriverUserModel userModelData = userModel.value;
    userModelData.fullName = nameController.value.text;
    userModelData.slug = nameController.value.text.toSlug(delimiter: "-");
    userModelData.email = emailController.value.text;
    userModelData.countryCode = countryCodeController.value.text;
    userModelData.phoneNumber = phoneNumberController.value.text;
    userModelData.gender = selectedGender.value == 1 ? "Male" : "Female";
    userModelData.profilePic = '';
    userModelData.fcmToken = fcmToken;
    userModelData.createdAt = Timestamp.now();
    userModelData.isActive = true;

    await FireStoreUtils.updateDriverUser(userModelData).then((value) async {
      DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(userModelData.id ?? '');
      if (userModel != null) {
        if (userModel.isActive == true) {
          if (userModel.isVerified ?? false) {
            bool permissionGiven = await Constant.isPermissionApplied();
            if (permissionGiven) {
              Get.offAll(const HomeView());
            } else {
              Get.offAll(const PermissionView());
            }
          } else {
            Get.offAll(const VerifyDocumentsView(isFromDrawer: false));
          }
        } else {
          await FirebaseAuth.instance.signOut();
          ShowToastDialog.showToast("user_disable_admin_contact".tr);
        }
      }
      ShowToastDialog.closeLoader();
    });
  }
}
