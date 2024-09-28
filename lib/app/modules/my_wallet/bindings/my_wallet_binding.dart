import 'package:get/get.dart';

import '../controllers/my_wallet_controller.dart';

class MyWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyWalletController>(
      () => MyWalletController(),
    );
  }
}
