import 'package:get/get.dart';

import '../controllers/review_screen_controller.dart';

class ReviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewScreenController>(
      () => ReviewScreenController(),
    );
  }
}
