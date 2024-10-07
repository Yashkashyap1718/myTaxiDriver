// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/extension/string_extensions.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController

  RxString profileImage = Constant.profileConstant.obs;
  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxInt selectedGender = 1.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getUserData();
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

  getUserData() async {
    DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(
        FireStoreUtils.getCurrentUid());
    if (userModel != null) {
      profileImage.value = (userModel.profilePic ?? "").isNotEmpty
          ? userModel.profilePic ?? Constant.profileConstant
          : Constant.profileConstant;
      name.value = userModel.fullName ?? '';
      nameController.text = userModel.fullName ?? '';
      phoneNumber.value =
          (userModel.countryCode ?? '') + (userModel.phoneNumber ?? '');
      phoneNumberController.text = (userModel.phoneNumber ?? '');
      emailController.text = (userModel.email ?? '');
      selectedGender.value = (userModel.gender ?? '') == "Male" ? 1 : 2;
    }
  }

  saveUserData() async {
    DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(
        FireStoreUtils.getCurrentUid());
    userModel!.gender = selectedGender.value == 1 ? "Male" : "Female";
    userModel.fullName = nameController.text;
    userModel.slug = nameController.text.toSlug(delimiter: "-");
    ShowToastDialog.showLoader("Please wait");
    if (profileImage.value.isNotEmpty &&
        Constant.hasValidUrl(profileImage.value) == false) {
      // profileImage.value = await Constant.uploadUserImageToFireStorage(
      //   File(profileImage.value),
      //   "profileImage/${FireStoreUtils.getCurrentUid()}",
      //   File(profileImage.value).path.split('/').last,
      // );
    }
    userModel.profilePic = profileImage.value;
    await FireStoreUtils.updateDriverUser(userModel);
    ShowToastDialog.closeLoader();
    Get.back(result: true);
  }

  Future<void> pickFile({required ImageSource source}) async {
    try {
      XFile? image =
          await imagePicker.pickImage(source: source, imageQuality: 100);
      if (image == null) return;

      Get.back();

      // Compress the image using flutter_image_compress
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      // Save the compressed image to a new file
      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes!);

      profileImage.value = compressedFile.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

// complete SignUp Profile
  Future<void> completeSignupProfile(
      String token, String name, String gender, String referralCode) async {
    const String url = 'http://172.93.54.177:3002/users/complete';

    final Map<String, String> payload = {
      "name": name,
      "gender": gender,
      "referral_code": referralCode,
    };

    try {
      ShowToastDialog.showLoader("Completing profile...".tr);

      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Handle the successful response as needed
        ShowToastDialog.closeLoader();
        Get.back(
            result: true); // Optionally navigate back or show a success message
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Profile completed successfully!')),
        );
      } else {
        throw Exception('Failed to complete signup profile');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint('Error completing profile: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
            content: Text('Error occurred while completing profile.')),
      );
    }
  }

  // Upload Profile
  Future<void> uploadProfile(String token) async {
    const String url = 'http://172.93.54.177:3002/users/profile/upload';

    // Read the image file and convert it to base64
    String base64Image = '';
    if (profileImage.value.isNotEmpty) {
      final bytes = File(profileImage.value).readAsBytesSync();
      base64Image = base64Encode(bytes);
    }

    final Map<String, String> payload = {
      "profile": base64Image,
    };

    try {
      ShowToastDialog.showLoader("Uploading profile...".tr);

      final http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status']) {
          ShowToastDialog.closeLoader();
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
          // Optionally, you can update the user's profile image URL in your app here
        } else {
          throw Exception(data['msg']);
        }
      } else {
        throw Exception('Failed to upload profile');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint('Error uploading profile: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
            content: Text('Error occurred while uploading profile.')),
      );
    }
  }
}
