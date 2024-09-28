
import 'package:driver/app/modules/create_support_ticket/controllers/create_support_ticket_controller.dart';
import 'package:get/get.dart';

class CreateSupportTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSupportTicketController>(() => CreateSupportTicketController());
  }
}
