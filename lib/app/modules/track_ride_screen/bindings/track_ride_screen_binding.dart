import 'package:get/get.dart';

import '../controllers/track_ride_screen_controller.dart';

class TrackRideScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackRideScreenController>(
      () => TrackRideScreenController(),
    );
  }
}
