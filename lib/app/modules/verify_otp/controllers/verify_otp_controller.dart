import 'dart:convert';

import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/constant/api_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';

import 'package:http/http.dart' as http;

class VerifyOtpController extends GetxController {
  RxString otpCode = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  @override
  void onClose() {}

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
    }
    isLoading.value = false;
    update();
  }

  Future<bool> sendOTP() async {
    ShowToastDialog.showLoader("please_wait".tr);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode.value + phoneNumber.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId0, int? resendToken0) async {
        verificationId.value = verificationId0;
        resendToken.value = resendToken0!;
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: resendToken.value,
      codeAutoRetrievalTimeout: (String verificationId0) {
        verificationId0 = verificationId.value;
      },
    );
    ShowToastDialog.closeLoader();
    return true;
  }

  Future<void> confirmOTP(
      BuildContext context, String otp, String phoneNumber) async {
    final Map<String, String> payload = {
      "otp": otp,
      "mobile_number": phoneNumber,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(baseURL + veriftOtpEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      Get.offAll(const HomeView());
      if (response.statusCode == 200) {
        final String token = data['token'];
        final String id = data['id'];
        final String roleType = data['type'];
        final String firstDigit = id.substring(0, 1);
        final int firstDigitAsInt = int.parse(firstDigit, radix: 16);

        // Show success message with Animated SnackBar
        // AnimatedSnackBar.material(
        //   'Welcome! User $phoneNumber',
        //   type: AnimatedSnackBarType.success,
        //   duration: const Duration(seconds: 5),
        //   mobileSnackBarPosition: MobileSnackBarPosition.top,
        // ).show(context);

        // Store token or other relevant data in provider or local storage
        // prrovider.setAccessToken(token);

        // Navigate to HomeScreen or the relevant page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        throw Exception('Failed to confirm OTP');
      }
    } catch (e) {
      debugPrint('Error: during OTP confirmation----------- $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while confirming OTP.'),
        ),
      );
    }
  }
}
