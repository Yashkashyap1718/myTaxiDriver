import 'package:get/get.dart';

import '../controllers/ask_for_otp_controller.dart';

class AskForOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AskForOtpController>(
      () => AskForOtpController(),
    );
  }
}
