import 'dart:convert';

import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/services/localization_service.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/language_controller.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LanguageController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "Language".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(Responsive.width(45, context) / 2, 10, Responsive.width(45, context) / 2, 10),
              child: RoundShapeButton(
                title: "Save".tr,
                buttonColor: AppThemData.primary500,
                buttonTextColor: AppThemData.black,
                onTap: () {
                  LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                  Preferences.setString(
                    Preferences.languageCodeKey,
                    jsonEncode(
                      controller.selectedLanguage.value,
                    ),
                  );
                  Get.back();
                },
                size: Size(Responsive.width(45, context), 52),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Container(
                    width: Responsive.width(100, context),
                    padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                    margin: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Column(
                            children: [
                              RadioListTile(
                                value: controller.languageList[index],
                                contentPadding: EdgeInsets.zero,
                                groupValue: controller.selectedLanguage.value,
                                controlAffinity: ListTileControlAffinity.trailing,
                                activeColor: AppThemData.primary500,
                                onChanged: (value) {
                                  controller.selectedLanguage.value = value!;
                                },
                                title: Text(
                                  controller.languageList[index].name.toString(),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (index != (controller.languageList.length - 1)) const Divider()
                            ],
                          ),
                        );
                      },
                      itemCount: controller.languageList.length,
                    ),
                  ),
          );
        });
  }
}
