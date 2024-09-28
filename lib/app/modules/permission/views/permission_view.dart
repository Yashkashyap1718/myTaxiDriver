import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/permission_controller.dart';

class PermissionView extends StatelessWidget {
  const PermissionView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: PermissionController(),
        builder: (controller) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/icon/gif_location.gif",
                    height: 120.0,
                    width: 120.0,
                  ),
                ),
                Text(
                  '${'Welcome to'.tr} ${Constant.appName}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 40),
                  child: Text(
                    'Enable location access to enjoy seamless ride experiences and reliable transportation services wherever you go.'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                RoundShapeButton(
                  size: const Size(208, 52),
                  title: "Allow Access".tr,
                  buttonColor: AppThemData.primary500,
                  buttonTextColor: AppThemData.black,
                  onTap: () {
                    controller.updatePermissions();
                  },
                ),
              ],
            ),
          );
        });
  }
}
