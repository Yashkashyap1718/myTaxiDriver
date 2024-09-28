
import 'package:driver/app/models/support_ticket_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SupportScreenController extends GetxController {
  RxList<SupportTicketModel> supportTicketList = <SupportTicketModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getSupportTicket(FirebaseAuth.instance.currentUser!.uid).then((value) {
      supportTicketList.value = value;
      isLoading(false);
    });
  }
}
