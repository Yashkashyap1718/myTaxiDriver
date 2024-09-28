import 'package:get/get.dart';

import '../controllers/verify_documents_controller.dart';

class VerifyDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDocumentsController>(
      () => VerifyDocumentsController(),
    );
  }
}
