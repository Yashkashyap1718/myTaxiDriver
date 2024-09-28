import 'package:driver/app/modules/intro_screen/views/widgets/intro_screen_page.dart';
import 'package:driver/app/modules/login/views/login_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/dependency_packages/circular_percent_indicator.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/intro_screen_controller.dart';

class IntroScreenView extends StatelessWidget {
  const IntroScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroScreenController>(
        init: IntroScreenController(),
        builder: (controller) {
          return Obx(
            () => Scaffold(
              backgroundColor: controller.currentPage.value == 0
                  ? AppThemData.intro1
                  : controller.currentPage.value == 1
                      ? AppThemData.intro2
                      : AppThemData.intro3,
              appBar: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: controller.currentPage.value == 0
                    ? AppThemData.intro1
                    : controller.currentPage.value == 1
                        ? AppThemData.intro2
                        : AppThemData.intro3,
                leading: Visibility(
                  visible: controller.currentPage.value != 0,
                  child: IconButton(
                      onPressed: () {
                        controller.currentPage.value = controller.currentPage.value - 1;
                        controller.pageController.jumpToPage(controller.currentPage.value);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: AppThemData.black,
                      )),
                ),
                actions: [
                  Visibility(
                    visible: controller.currentPage.value != 2,
                    child: TextButton(
                        onPressed: () {
                          Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                          Get.offAll(const LoginView());
                        },
                        child: Row(
                          children: [
                            Text(
                              "Skip".tr,
                              style: GoogleFonts.inter(fontSize: 16.0, color: AppThemData.grey950, fontWeight: FontWeight.w500),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                              color: AppThemData.black,
                            )
                          ],
                        )),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        controller.currentPage.value = index;
                      },
                      children: [
                        IntroScreenPage(
                          title: "Welcome to MyTaxi".tr,
                          body: "Your reliable partner for swift and convenient rides. Experience hassle-free transportation at your fingertips.",
                          image: "assets/icon/intro_image_one.svg",
                        ),
                        IntroScreenPage(
                          title: " Fast and Reliable".tr,
                          body: "MyTaxi ensures prompt and reliable rides, getting you to your destination with speed and efficiency.",
                          image: "assets/icon/intro_image_two.svg",
                        ),
                        IntroScreenPage(
                          title: "Seamless User Experience".tr,
                          body: "Enjoy a user-friendly interface, easy bookings, and secure payments with MyTaxi. Your journey, your way.",
                          image: "assets/icon/intro_image_three.svg",
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.currentPage.value != 2,
                    child: CircularPercentIndicator(
                      radius: 35,
                      lineWidth: 5.0,
                      percent: controller.currentPage.value == 0
                          ? 0.33
                          : controller.currentPage.value == 1
                              ? 0.66
                              : 1.0,
                      center: InkWell(
                        onTap: () {
                          controller.currentPage.value = controller.currentPage.value + 1;
                          controller.pageController.jumpToPage(controller.currentPage.value);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(color: AppThemData.primary500, borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ),
                      progressColor: AppThemData.primary500,
                      backgroundColor: AppThemData.grey50,
                    ),
                  ),
                  Visibility(
                    visible: controller.currentPage.value == 2,
                    child: RoundShapeButton(
                        size: const Size(200, 45),
                        title: "Get Started".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                          Get.offAll(const LoginView());
                        }),
                  ),
                  SizedBox(height: Responsive.width(10, context))
                ],
              ),
            ),
          );
        });
  }
}
