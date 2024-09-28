import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDataView extends StatelessWidget {
  final double? height;

  const NoDataView({
    super.key,
    required this.themeChange,
    this.height,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? Responsive.height(50, context),
      width: Responsive.height(100, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/animation/error.gif',
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'No Data Found'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
