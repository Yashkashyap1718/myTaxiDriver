// ignore_for_file: unnecessary_overrides, invalid_return_type_for_catch_error

import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/permission/views/permission_view.dart';
import 'package:driver/app/modules/signup/views/signup_view.dart';
import 'package:driver/app/modules/verify_otp/views/verify_otp_view.dart';
import 'package:driver/constant/api_constant.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> sendOTP(BuildContext context) async {
    final Map<String, String> payload = {
      "country_code": "91", // Assuming you want to keep this static for now
      "mobile_number": phoneNumberController.text, // Dynamic phone number input
    };

    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final response = await http.post(
        Uri.parse(baseURL + sendOtpEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');
      print('----sendOTP----');

      print('---pay--$payload');
      log(response.body); // Log the response body for debugging

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract the "msg" field which contains the OTP
        final String msg = responseData['msg'];
        // Split the message by comma to get the OTP (the first part)
        final List<String> parts = msg.split(',');
        final String otp =
            parts.first.trim(); // Trim to remove any surrounding spaces
        print('Extracted OTP: $otp');
        // Navigate to OTP verification screen with the phone number and OTP
        Get.to(
          () => VerifyOtpView(
              // oTP: otp,
              // phoneNumder: phoneNumberController.text,

              // Pass the extracted OTP
              ),
        );
        ShowToastDialog.closeLoader();

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(otp),
        //   ),
        // );
      } else {
        // Handle unsuccessful response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${response.reasonPhrase}'),
          ),
        );
      }
    } catch (e) {
      log('Error: $e'); // Log any errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while sending request.'),
        ),
      );

      print(e);
    }
  }

  sendCode() async {
    try {
      ShowToastDialog.showLoader("please_wait".tr);
      await FirebaseAuth.instance
          .verifyPhoneNumber(
        phoneNumber:
            countryCodeController.value.text + phoneNumberController.value.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("FirebaseAuthException--->${e.message}");
          ShowToastDialog.closeLoader();
          if (e.code == 'invalid-phone-number') {
            ShowToastDialog.showToast("invalid_phone_number".tr);
          } else {
            ShowToastDialog.showToast(e.code);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          ShowToastDialog.closeLoader();
          Get.to(() => const VerifyOtpView(), arguments: {
            "countryCode": countryCodeController.value.text,
            "phoneNumber": phoneNumberController.value.text,
            "verificationId": verificationId,
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      )
          .catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("multiple_time_request".tr);
      });
    } catch (e) {
      log(e.toString());
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something went wrong!".tr);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        return null;
      });

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
    // Trigger the authentication flow
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
        nonce: nonce,
      ).catchError((error) {
        debugPrint("catchError--->$error");
        ShowToastDialog.closeLoader();
        return null;
      });

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  loginWithGoogle() async {
    ShowToastDialog.showLoader("please_wait".tr);
    await signInWithGoogle().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          DriverUserModel userModel = DriverUserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.fullName = value.user!.displayName;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.googleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(() => const SignupView(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              DriverUserModel? userModel =
                  await FireStoreUtils.getDriverUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  bool permissionGiven = await Constant.isPermissionApplied();
                  if (permissionGiven) {
                    Get.offAll(const HomeView());
                  } else {
                    Get.offAll(const PermissionView());
                  }
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("user_disable_admin_contact".tr);
                }
              }
            } else {
              DriverUserModel userModel = DriverUserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.fullName = value.user!.displayName;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(() => const SignupView(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("please_wait".tr);
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          DriverUserModel userModel = DriverUserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(() => const SignupView(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              DriverUserModel? userModel =
                  await FireStoreUtils.getDriverUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  bool permissionGiven = await Constant.isPermissionApplied();
                  if (permissionGiven) {
                    Get.offAll(const HomeView());
                  } else {
                    Get.offAll(const PermissionView());
                  }
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("user_disable_admin_contact".tr);
                }
              }
            } else {
              DriverUserModel userModel = DriverUserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(() => const SignupView(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    }).onError((error, stackTrace) {
      log("===> $error");
    });
  }
}
