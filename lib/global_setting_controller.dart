import 'dart:developer';

import 'package:driver/app/models/currencies_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/extension/hax_color_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:driver/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'services/localization_service.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await notificationInit();
    await getCurrentCurrency();
    await getVehicleTypeList();
    await getLanguage();
    // getTax();
  }

  getCurrentCurrency() async {
    await FireStoreUtils().getCurrency().then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "USD", decimalDigits: 2, active: true, name: "US Dollar", symbol: "\$", symbolAtRight: false);
      }
    });
    await FireStoreUtils().getSettings();
    await FireStoreUtils().getPayment();
    AppThemData.primary500 = HexColor.fromHex(Constant.appColor.toString());
  }

  getVehicleTypeList() async {
    await FireStoreUtils.getVehicleType().then((value) {
      if (value != null) {
        Constant.vehicleTypeList = value;
      }
    });
  }

  getLanguage() async {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = await Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    } else {
      LanguageModel languageModel = LanguageModel(
        id: "CcrGiUvJbPTXaU31s5l8",
        name: "English",
        code: "en",
      );
      LocalizationService().changeLocale(languageModel.code.toString());
    }
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOKEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            DriverUserModel userModel = value;
            userModel.fcmToken = token;
            FireStoreUtils.updateDriverUser(userModel);
          }
        });
      }
    });
  }

  // getTax() async {
  //   await FireStoreUtils().getTaxList().then((value) {
  //     if (value != null) {
  //       Constant.taxList = value;
  //     }
  //   });
  // }
}
