import 'dart:developer';

import 'package:driver/app/models/support_ticket_model.dart';
import 'package:get/get.dart';

class SupportTicketDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<SupportTicketModel> supportTicketModel = SupportTicketModel().obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  getArguments() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      supportTicketModel.value = argumentData["supportTicket"];
    }
    log(supportTicketModel.value.toString());
    isLoading.value = false;
  }
}
