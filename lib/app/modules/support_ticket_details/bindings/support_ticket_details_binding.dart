
import 'package:driver/app/modules/support_ticket_details/controllers/support_ticket_details_controller.dart';
import 'package:get/get.dart';

class SupportTicketDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketDetailsController>(() => SupportTicketDetailsController());
  }
}
