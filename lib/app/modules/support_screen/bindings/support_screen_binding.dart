
import 'package:driver/app/modules/support_screen/controllers/support_screen_controller.dart';
import 'package:get/get.dart';

class SupportScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportScreenController>(() => SupportScreenController());
  }
}
