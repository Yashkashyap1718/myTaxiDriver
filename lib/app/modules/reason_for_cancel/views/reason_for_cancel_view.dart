import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/reason_for_cancel_controller.dart';

class ReasonForCancelView extends StatelessWidget {
  final BookingModel bookingModel;

  const ReasonForCancelView({super.key, required this.bookingModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: ReasonForCancelController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
                title: "Reasons for Canceling Ride".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundShapeButton(
                    title: "Cancel".tr,
                    buttonColor: AppThemData.grey50,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      Get.back();
                    },
                    size: Size(Responsive.width(45, context), 52),
                  ),
                  RoundShapeButton(
                    title: "Continue".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () async {
                      bool isCancelled = await controller.cancelBooking(bookingModel);
                      if (isCancelled) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return CustomDialogBox(
                              title: "Your ride is successfully cancelled.",
                              descriptions: "We hope to serve you better next time.",
                              img: Image.asset(
                                "assets/icon/ic_green_right.png",
                                height: 58,
                                width: 58,
                              ),
                              positiveClick: () {
                                // controller.sendCancelRideNotification();
                                ShowToastDialog.showToast("Ride Cancelled Successfully..");
                                Navigator.pop(context);
                                Get.back();
                                // Get.offAll(const HomeView());
                              },
                              negativeClick: () {
                                Navigator.pop(context);
                              },
                              positiveString: "Back to Home".tr,
                              negativeString: "Cancel".tr,
                              themeChange: themeChange,
                              negativeButtonColor: AppThemData.grey50,
                              negativeButtonTextColor: AppThemData.grey950,
                            );
                          },
                        );
                      } else {
                        ShowToastDialog.showToast("Something went wrong!".tr);
                      }
                    },
                    size: Size(Responsive.width(45, context), 52),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Column(
                            children: [
                              RadioListTile(
                                value: index,
                                contentPadding: EdgeInsets.zero,
                                groupValue: controller.selectedIndex.value,
                                controlAffinity: ListTileControlAffinity.trailing,
                                activeColor: AppThemData.primary500,
                                onChanged: (ind) {
                                  controller.selectedIndex.value = ind ?? 0;
                                },
                                title: Text(
                                  controller.reasons[index],
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (index != (controller.reasons.length - 1)) const Divider()
                            ],
                          ),
                        );
                      },
                      itemCount: controller.reasons.length,
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.reasons[controller.selectedIndex.value] == "Other",
                        child: TextFormField(
                          enabled: controller.reasons[controller.selectedIndex.value] == "Other",
                          textAlign: TextAlign.start,
                          minLines: 3,
                          maxLines: 5,
                          controller: controller.otherReasonController.value,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Type here...'.tr,
                              fillColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
