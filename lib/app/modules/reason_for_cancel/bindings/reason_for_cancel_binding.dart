import 'package:get/get.dart';

import '../controllers/reason_for_cancel_controller.dart';

class ReasonForCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReasonForCancelController>(
      () => ReasonForCancelController(),
    );
  }
}
