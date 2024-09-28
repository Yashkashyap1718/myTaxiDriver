import 'package:driver/theme/app_them_data.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
      primaryColor: isDarkTheme ? AppThemData.primary400 : AppThemData.primary500,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      drawerTheme: DrawerThemeData(
        backgroundColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
        surfaceTintColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemData.grey700 : AppThemData.grey200,
        dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800),
        dialTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
        hourMinuteTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
        dayPeriodTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
      ),
    );
  }
}
