import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/country_code_selector_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SignupController>(
        init: SignupController(),
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
              body: SafeArea(
                child: Container(
                  width: Responsive.width(100, context),
                  height: Responsive.height(100, context),
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.formKey.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Responsive.height(5, context), bottom: 32),
                            child: Center(child: SvgPicture.asset(themeChange.isDarkTheme() ? "assets/icon/taxi.png" : "assets/icon/taxi.png")),
                          ),
                          Text(
                            "Create Account".tr,
                            style: GoogleFonts.inter(fontSize: 24, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Create an account to start ride.".tr,
                            style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 36),
                          TextFieldWithTitle(
                            title: "Full Name".tr,
                            hintText: "Enter Full Name".tr,
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            controller: controller.nameController,
                            validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Email Address".tr,
                            hintText: "Enter Email Address".tr,
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.emailController,
                            isEnable: controller.loginType.value == Constant.phoneLoginType,
                            validator: (value) => Constant().validateEmail(value),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Phone Number".tr,
                            hintText: "Enter Phone Number".tr,
                            prefixIcon: CountryCodeSelectorView(
                              isCountryNameShow: false,
                              countryCodeController: controller.countryCodeController,
                              isEnable: controller.loginType.value != Constant.phoneLoginType,
                              onChanged: (value) {
                                controller.countryCodeController.text = value.dialCode.toString();
                              },
                            ),
                            validator: (value) => validateMobile(value, controller.countryCodeController.value.text),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            ],
                            controller: controller.phoneNumberController,
                            isEnable: controller.loginType.value != Constant.phoneLoginType,
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     CountryCodeSelectorView(
                          //       countryCodeController: controller.countryCodeController,
                          //       isEnable: controller.loginType.value != Constant.phoneLoginType,
                          //       onChanged: (value) {
                          //         controller.countryCodeController.text = value.dialCode.toString();
                          //       },
                          //     ),
                          //     Container(
                          //       transform: Matrix4.translationValues(0.0, -05.0, 0.0),
                          //       child: TextFormField(
                          //         cursorColor: Colors.black,
                          //         keyboardType: TextInputType.number,
                          //         controller: controller.phoneNumberController,
                          //         enabled: controller.loginType.value != Constant.phoneLoginType,
                          //         inputFormatters: <TextInputFormatter>[
                          //           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          //         ],
                          //         style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w400),
                          //         decoration: InputDecoration(
                          //           border: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                          //           focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                          //           enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                          //           errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                          //           disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                          //           hintText: "Enter your Phone Number".tr,
                          //           hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender".tr,
                                style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: controller.selectedGender.value,
                                  activeColor: AppThemData.primary500,
                                  onChanged: (value) {
                                    controller.selectedGender.value = value ?? 1;
                                    // _radioVal = 'male';
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedGender.value = 1;
                                  },
                                  child: Text(
                                    'Male'.tr,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: controller.selectedGender.value == 1
                                            ? themeChange.isDarkTheme()
                                                ? AppThemData.white
                                                : AppThemData.grey950
                                            : AppThemData.grey500,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: controller.selectedGender.value,
                                  activeColor: AppThemData.primary500,
                                  onChanged: (value) {
                                    controller.selectedGender.value = value ?? 2;
                                    // _radioVal = 'female';
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedGender.value = 2;
                                  },
                                  child: Text(
                                    'Female'.tr,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: controller.selectedGender.value == 2
                                            ? themeChange.isDarkTheme()
                                                ? AppThemData.white
                                                : AppThemData.grey950
                                            : AppThemData.grey500,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: RoundShapeButton(
                                size: const Size(200, 45),
                                title: "Sign Up".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {
                                  if (controller.formKey.value.currentState!.validate()) {
                                    controller.createAccount();
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
