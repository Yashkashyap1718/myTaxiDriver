import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/vehicle_brand_model.dart';
import 'package:driver/app/models/vehicle_model_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/modules/verify_documents/controllers/verify_documents_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateVehicleDetailsController extends GetxController {
  Rx<VehicleTypeModel> vehicleTypeModel = VehicleTypeModel(
      id: "",
      image: "",
      isActive: false,
      title: "",
      persons: "0",
      charges: Charges(
        fareMinimumChargesWithinKm: "0",
        farMinimumCharges: "0",
        farePerKm: "0",
      )).obs;
  Rx<VehicleBrandModel> vehicleBrandModel =
      VehicleBrandModel(id: "", title: "", isEnable: false).obs;
  Rx<VehicleModelModel> vehicleModelModel =
      VehicleModelModel(id: "", title: "", isEnable: false, brandId: '').obs;
  List<VehicleTypeModel> vehicleTypeList = Constant.vehicleTypeList ?? [];
  RxList<VehicleBrandModel> vehicleBrandList = <VehicleBrandModel>[].obs;
  RxList<VehicleModelModel> vehicleModelList = <VehicleModelModel>[].obs;
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  @override
  Future<void> onReady() async {
    vehicleTypeModel.value = vehicleTypeList[0];
    vehicleBrandList.value = await FireStoreUtils.getVehicleBrand() ?? [];
    updateData();
    super.onReady();
  }

  updateData() {
    VerifyDocumentsController uploadDocumentsController =
        Get.find<VerifyDocumentsController>();
    if (uploadDocumentsController.userModel.value.driverVehicleDetails !=
        null) {
      int typeIndex = vehicleTypeList.indexWhere((element) =>
          element.id ==
          uploadDocumentsController
              .userModel.value.driverVehicleDetails!.vehicleTypeId);
      print("Type Index : $typeIndex");
      if (typeIndex != -1) vehicleTypeModel.value = vehicleTypeList[typeIndex];
      vehicleBrandController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.brandName ??
          '';
      vehicleModelController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.modelName ??
          '';
      vehicleNumberController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.vehicleNumber ??
          '';
    }
  }

  getVehicleModel(String id) async {
    vehicleModelList.value = await FireStoreUtils.getVehicleModel(id) ?? [];
  }

  saveVehicleDetails() async {
    ShowToastDialog.showLoader("please_wait".tr);
    VerifyDocumentsController verifyDocumentsController =
        Get.find<VerifyDocumentsController>();
    DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(
        FireStoreUtils.getCurrentUid());
    if (userModel == null) return;
    DriverVehicleDetails driverVehicleDetails = DriverVehicleDetails(
      brandName: vehicleBrandModel.value.title,
      brandId: vehicleBrandModel.value.id,
      modelName: vehicleModelModel.value.title,
      modelId: vehicleModelModel.value.id,
      vehicleNumber: vehicleNumberController.text,
      isVerified: false,
      vehicleTypeName: vehicleTypeModel.value.title,
      vehicleTypeId: vehicleTypeModel.value.id,
    );
    userModel.driverVehicleDetails = driverVehicleDetails;
    print("==> ${userModel.driverVehicleDetails!.toJson()}");

    bool isUpdated = await FireStoreUtils.updateDriverUser(userModel);
    ShowToastDialog.closeLoader();
    if (isUpdated) {
      ShowToastDialog.showToast(
          "Vehicle details updated, Please wait for verification.");
      verifyDocumentsController.getData();
      Get.back();
    } else {
      ShowToastDialog.showToast(
          "Something went wrong, Please try again later.");
      Get.back();
    }
  }
}
