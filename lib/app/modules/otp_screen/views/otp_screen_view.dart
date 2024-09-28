import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../controllers/otp_screen_controller.dart';

class OtpScreenView extends StatelessWidget {
  final BookingModel bookingModel;

  const OtpScreenView({
    super.key,
    required this.bookingModel,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: OtpScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              title: const Text(''),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Enter OTP to Start Ride'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please enter the OTP which provided by customer to confirm your acceptance of the ride request.'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 86),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 40,
                    style: GoogleFonts.inter(fontSize: 16, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w500),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    otpFieldStyle: OtpFieldStyle(
                      focusBorderColor: AppThemData.primary500,
                      borderColor: AppThemData.grey100,
                      enabledBorderColor: AppThemData.grey100,
                    ),
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) async {
                      controller.otp.value = pin;
                    },
                  ),
                  const SizedBox(height: 83),
                  RoundShapeButton(
                      size: const Size(200, 45),
                      title: "Submit".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () async {
                        if (controller.otp.value == bookingModel.otp) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                    themeChange: themeChange,
                                    title: "Confirm Ride Request".tr,
                                    descriptions:
                                        "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.".tr,
                                    positiveString: "Confirm".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      controller.startBooking(bookingModel);
                                      Navigator.pop(context);
                                      // Get.offAll(const HomeView());
                                      Get.back();
                                      Get.back();
                                      // Get.to(const HomeView());
                                    },
                                    negativeClick: () {
                                      Navigator.pop(context);
                                    },
                                    img: Image.asset(
                                      "assets/icon/ic_green_right.png",
                                      height: 58,
                                      width: 58,
                                    ));
                              });
                        } else {
                          ShowToastDialog.showToast("Please enter a valid OTP.".tr);
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
