import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/constant/custom_search_dialog.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/update_vehicle_details_controller.dart';

class UpdateVehicleDetailsView extends StatelessWidget {
  final bool isUploaded;

  const UpdateVehicleDetailsView({super.key, required this.isUploaded});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: UpdateVehicleDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Vehicle Details".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Vehicle Type'.tr,
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 70.0,
                      width: Responsive.width(100, context),
                      margin: const EdgeInsets.only(top: 16, bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Obx(
                          () => DropdownButton<VehicleTypeModel>(
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                            ),
                            hint: Text(
                              "Select Vehicle Type".tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                                fontSize: 16,
                              ),
                            ),
                            itemHeight: 70,
                            dropdownColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                            padding: const EdgeInsets.only(right: 12),
                            selectedItemBuilder: (context) {
                              return controller.vehicleTypeList.map((VehicleTypeModel value) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        value.image,
                                        height: 42,
                                        width: 42,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(value.title),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                            items: controller.vehicleTypeList.map<DropdownMenuItem<VehicleTypeModel>>((VehicleTypeModel value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          value.image,
                                          height: 42,
                                          width: 42,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(value.title),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(visible: controller.vehicleTypeList.indexOf(value) != (controller.vehicleTypeList.length - 1), child: const Divider())
                                  ],
                                ),
                              );
                            }).toList(),
                            borderRadius: BorderRadius.circular(12),
                            isExpanded: false,
                            isDense: false,
                            onChanged: isUploaded
                                ? null
                                : (VehicleTypeModel? newSelectedBank) {
                                    controller.vehicleTypeModel.value = newSelectedBank!;
                                  },
                            value: controller.vehicleTypeModel.value,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: isUploaded
                          ? null
                          : () {
                              CustomSearchDialog.vehicleBrandSearchDialog(
                                  bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                  context: context,
                                  title: "Search Vehicle Brand",
                                  list: controller.vehicleBrandList);
                            },
                      child: TextFieldWithTitle(
                        title: "Vehicle Brand".tr,
                        hintText: "Select Vehicle Brand".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.vehicleBrandController,
                        isEnable: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: isUploaded
                          ? null
                          : () {
                              CustomSearchDialog.vehicleModelSearchDialog(
                                  bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                  context: context,
                                  title: "Search Vehicle Model",
                                  list: controller.vehicleModelList);
                            },
                      child: TextFieldWithTitle(
                        title: "Vehicle Model".tr,
                        hintText: "Select Vehicle Model".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.vehicleModelController,
                        isEnable: false,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFieldWithTitle(
                      title: "Vehicle Number".tr,
                      hintText: "Select Vehicle Number".tr,
                      keyboardType: TextInputType.text,
                      controller: controller.vehicleNumberController,
                      isEnable: !isUploaded,
                    ),
                    const SizedBox(height: 32),
                    Visibility(
                      visible: !isUploaded,
                      child: Center(
                        child: RoundShapeButton(
                          title: "Submit".tr,
                          buttonColor: AppThemData.primary500,
                          buttonTextColor: AppThemData.black,
                          onTap: () {
                            if (controller.vehicleBrandController.text.isNotEmpty &&
                                controller.vehicleModelController.text.isNotEmpty &&
                                controller.vehicleNumberController.text.isNotEmpty) {
                              controller.saveVehicleDetails();
                            } else {
                              ShowToastDialog.showToast("Please enter a valid details".tr);
                            }
                          },
                          size: const Size(208, 52),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
