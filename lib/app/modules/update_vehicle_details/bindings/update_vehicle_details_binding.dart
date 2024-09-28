import 'package:get/get.dart';

import '../controllers/update_vehicle_details_controller.dart';

class UpdateVehicleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateVehicleDetailsController>(
      () => UpdateVehicleDetailsController(),
    );
  }
}
