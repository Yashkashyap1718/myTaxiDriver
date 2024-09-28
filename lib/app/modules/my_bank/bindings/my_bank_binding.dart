import 'package:get/get.dart';

import '../controllers/my_bank_controller.dart';

class MyBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBankController>(
      () => MyBankController(),
    );
  }
}
