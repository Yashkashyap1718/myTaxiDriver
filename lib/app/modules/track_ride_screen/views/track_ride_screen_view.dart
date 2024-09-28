import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/track_ride_screen_controller.dart';

class TrackRideScreenView extends GetView<TrackRideScreenController> {
  const TrackRideScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
        init: TrackRideScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            // appBar: AppBarWithBorder(title: "Select Location", bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            body: Stack(
              children: [
                SizedBox(
                  height: Responsive.height(100, context),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(controller.bookingModel.value.pickUpLocation!.latitude ?? 0.0, controller.bookingModel.value.pickUpLocation!.longitude ?? 0.0),
                      zoom: 5,
                    ),
                    padding: const EdgeInsets.only(
                      top: 22.0,
                    ),
                    polylines: Set<Polyline>.of(controller.polyLines.values),
                    markers: Set<Marker>.of(controller.markers.values),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.fromLTRB(20, 55, 20, 30),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back,
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
