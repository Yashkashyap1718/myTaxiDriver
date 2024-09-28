import 'dart:io';

import 'package:driver/constant_widgets/country_code_selector_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../theme/responsive.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              bool isFocus = FocusScope.of(context).hasFocus;
              if (isFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              appBar: AppBar(forceMaterialTransparency: true, backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white, automaticallyImplyLeading: false),
              body: Container(
                width: Responsive.width(100, context),
                height: Responsive.height(100, context),
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Center(child: SvgPicture.asset(themeChange.isDarkTheme() ? "assets/icon/splash_logo.svg" : "assets/icon/logo_black.svg")),
                      ),
                      Text(
                        "Login".tr,
                        style: GoogleFonts.inter(fontSize: 24, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Please login to continue".tr,
                        style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w400),
                      ),
                      Container(
                        height: 110,
                        width: Responsive.width(100, context),
                        margin: const EdgeInsets.only(top: 36, bottom: 48),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppThemData.grey100)),
                        child: Form(
                          key: controller.formKey.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 45,
                                padding: const EdgeInsets.all(8.0),
                                child: CountryCodeSelectorView(
                                  isCountryNameShow: true,
                                  countryCodeController: controller.countryCodeController,
                                  isEnable: true,
                                  onChanged: (value) {
                                    controller.countryCodeController.text = value.dialCode.toString();
                                  },
                                ),
                              ),
                              const Divider(color: AppThemData.grey100),
                              SizedBox(
                                height: 45,
                                child: TextFormField(
                                  cursorColor: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                  keyboardType: TextInputType.number,
                                  controller: controller.phoneNumberController,
                                  validator: (value) => validateMobile(value, controller.countryCodeController.value.text),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                                    hintText: "Enter your Phone Number".tr,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: RoundShapeButton(
                            size: const Size(200, 45),
                            title: "Send OTP".tr,
                            buttonColor: AppThemData.primary500,
                            buttonTextColor: AppThemData.black,
                            onTap: () {
                              if (controller.formKey.value.currentState!.validate()) {
                                controller.sendCode();
                              } else {
                                ShowToastDialog.showToast('Please enter a valid number'.tr);
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              margin: const EdgeInsets.only(right: 10),
                              child: const Divider(color: AppThemData.grey100),
                            ),
                            Text(
                              "Continue with".tr,
                              style: GoogleFonts.inter(fontSize: 12, color: AppThemData.grey400, fontWeight: FontWeight.w400),
                            ),
                            Container(
                              width: 52,
                              margin: const EdgeInsets.only(left: 10),
                              child: const Divider(color: AppThemData.grey100),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: Platform.isIOS,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              controller.loginWithApple();
                            },
                            child: Container(
                              height: 45,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  border: Border.all(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey100,
                                  )),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icon/ic_apple.svg",
                                    height: 24,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Apple'.tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: InkWell(
                          onTap: () {
                            controller.loginWithGoogle();
                          },
                          child: Container(
                            height: 45,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                border: Border.all(
                                  color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey100,
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/icon/ic_google.svg", height: 24, width: 24),
                                const SizedBox(width: 12),
                                Text(
                                  'Google'.tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
