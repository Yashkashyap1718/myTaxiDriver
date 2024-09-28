// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(THEME_STATUS, value);
  }

  Future<int> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME_STATUS) ?? 2;
  }
}
