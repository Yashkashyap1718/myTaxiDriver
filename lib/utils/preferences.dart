import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const languageCodeKey = "languageCodeKey";
  static const themKey = "themKey";
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";

  static Future<bool> getBoolean(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  static Future<void> setBoolean(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setInt(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(key, value);
  }

  static Future<void> clearSharPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  static Future<void> clearKeyData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }
}
