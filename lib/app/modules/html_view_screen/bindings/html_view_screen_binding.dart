import 'package:get/get.dart';

import '../controllers/html_view_screen_controller.dart';

class HtmlViewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HtmlViewScreenController>(
      () => HtmlViewScreenController(),
    );
  }
}
