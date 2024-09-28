import 'dart:io';

import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/country_code_selector_view.dart';
import 'package:driver/constant_widgets/network_image_widget.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: EditProfileController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Edit Profile".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: myProfileView(controller, context),

                      // Stack(
                      //   alignment: Alignment.bottomRight,
                      //   children: [
                      //     Obx(
                      //       () => Container(
                      //         width: 110,
                      //         height: 110,
                      //         clipBehavior: Clip.antiAlias,
                      //         decoration: ShapeDecoration(
                      //           color: Colors.white,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(200),
                      //           ),
                      //           image: DecorationImage(
                      //             image: NetworkImage(controller.profilePic.value),
                      //             fit: BoxFit.cover,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 26,
                      //       height: 26,
                      //       padding: const EdgeInsets.all(5),
                      //       margin: const EdgeInsets.only(bottom: 8),
                      //       clipBehavior: Clip.antiAlias,
                      //       decoration: ShapeDecoration(
                      //         color: AppThemData.primary500,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(200), side: const BorderSide(color: AppThemData.white, width: 3)),
                      //       ),
                      //       child: SvgPicture.asset(
                      //         "assets/icon/ic_drawer_edit.svg",
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Center(
                        child: Text(
                          controller.name.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Center(
                        child: Text(
                          controller.phoneNumber.value,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFieldWithTitle(
                      title: "Name".tr,
                      hintText: "Enter Name".tr,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWithTitle(
                      title: "Email".tr,
                      hintText: "Enter Email".tr,
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailController,
                      isEnable: false,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryCodeSelectorView(
                          isCountryNameShow: true,
                          countryCodeController: controller.countryCodeController,
                          isEnable: false,
                          onChanged: (value) {
                            controller.countryCodeController.text = value.dialCode.toString();
                          },
                        ),
                        Container(
                          transform: Matrix4.translationValues(0.0, -05.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            controller: controller.phoneNumberController,
                            enabled: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            ],
                            style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                              errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                              disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                              hintText: "Enter your Phone Number".tr,
                              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Gender".tr,
                      style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w500),
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
                    const SizedBox(height: 35),
                    Center(
                      child: RoundShapeButton(
                        title: "Save".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () {
                          controller.saveUserData();
                        },
                        size: const Size(208, 52),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  myProfileView(EditProfileController controller, BuildContext context) {
    return InkWell(
      onTap: () {
        buildBottomSheet(context, controller);
      },
      child: Center(
          child: SizedBox(
        height: Responsive.width(30, context),
        width: Responsive.width(30, context),
        child: Obx(
          () => Stack(
            children: [
              controller.profileImage.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        //boxShadow: [BoxShadow(offset: const Offset(5, 4), spreadRadius: .2, blurRadius: 12, color: AppColors.gallery400.withOpacity(.5))]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: NetworkImageWidget(imageUrl: controller.profileImage.value),
                      ),
                    )
                  : (Constant.hasValidUrl(controller.profileImage.value))
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            //  boxShadow: [BoxShadow(offset: const Offset(5, 4), spreadRadius: .2, blurRadius: 12, color: AppColors.gallery400.withOpacity(.5))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: NetworkImageWidget(
                              errorWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.asset(
                                  Constant.placeHolder,
                                  height: Responsive.height(8, context),
                                  width: Responsive.width(15, context),
                                ),
                              ),
                              imageUrl: controller.profileImage.value,
                              height: Responsive.width(30, context),
                              width: Responsive.width(30, context),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            // boxShadow: [BoxShadow(offset: const Offset(5, 4), spreadRadius: .2, blurRadius: 12, color: AppColors.gallery400.withOpacity(.5))]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              File(controller.profileImage.value),
                              height: Responsive.width(30, context),
                              width: Responsive.width(30, context),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: AppThemData.primary500,
                      radius: 18,
                      child: SvgPicture.asset("assets/icon/ic_drawer_edit.svg"),
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }

  buildBottomSheet(BuildContext context, EditProfileController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("Please Select".tr,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "Camera".tr,
                                style: GoogleFonts.inter(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "Gallery".tr,
                                style: GoogleFonts.inter(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
