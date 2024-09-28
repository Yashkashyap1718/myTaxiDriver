import 'package:get/get.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';

class LanguageController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading(true);
    languageList.clear();
    List<LanguageModel> data = await FireStoreUtils.getLanguage();
    languageList.addAll(data);
    LanguageModel temp = await Constant.getLanguage();
    selectedLanguage.value = languageList[languageList.indexWhere((element) => element.id == temp.id) ?? 0 ];
    isLoading(false);
  }
}
