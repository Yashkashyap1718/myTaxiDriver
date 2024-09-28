import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:driver/utils/dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  int _darkTheme = 0;

  int get darkTheme => _darkTheme;

  set darkTheme(int value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  bool isDarkTheme() {
    return darkTheme == 0
        ? true
        : darkTheme == 1
            ? false
            : DarkThemeProvider().getSystemThem();
  }

  bool getSystemThem() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
