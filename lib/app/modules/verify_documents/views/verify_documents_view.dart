import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/permission/views/permission_view.dart';
import 'package:driver/app/modules/update_vehicle_details/views/update_vehicle_details_view.dart';
import 'package:driver/app/modules/upload_documents/views/upload_documents_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/fire_store_utils.dart';
import '../controllers/verify_documents_controller.dart';

class VerifyDocumentsView extends GetView<VerifyDocumentsController> {
  final bool isFromDrawer;

  const VerifyDocumentsView({super.key, required this.isFromDrawer});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: VerifyDocumentsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemData.white,
            appBar: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: AppThemData.white,
              automaticallyImplyLeading: true,
              shape: const Border(
                  bottom: BorderSide(color: AppThemData.grey100, width: 1)),
              title: Text(
                "Verify your details".tr,
                style: GoogleFonts.inter(
                  color: AppThemData.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            floatingActionButton: isFromDrawer
                ? null
                : RoundShapeButton(
                    size: const Size(200, 45),
                    title: "Check Status".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () async {
                      var userModel = controller.userModel.value;
                      if (userModel.driverVehicleDetails != null &&
                          userModel.driverVehicleDetails!.brandId!.isNotEmpty) {
                        ShowToastDialog.showLoader("Please wait");
                        await controller.getData();
                        DriverUserModel? userModel =
                            await FireStoreUtils.getDriverUserProfile(
                                FireStoreUtils.getCurrentUid());
                        bool isUserVerified = userModel!.isVerified ?? false;
                        bool isVehicleDetailsVerified = controller.userModel
                                .value.driverVehicleDetails!.isVerified ??
                            false;
                        int index = controller
                            .verifyDriverModel.value.verifyDocument!
                            .indexWhere((element) => element.isVerify == false);
                        bool isDocumentVerified = index == -1;
                        if (isUserVerified &&
                            isVehicleDetailsVerified &&
                            isDocumentVerified) {
                          controller.isVerified.value = true;
                          bool permissionGiven =
                              await Constant.isPermissionApplied();
                          if (permissionGiven) {
                            Get.offAll(const HomeView());
                          } else {
                            Get.offAll(const PermissionView());
                          }
                        } else {
                          controller.isVerified.value = false;
                          if (!isUserVerified)
                            ShowToastDialog.showToast(
                                "User disabled by administrator, Please contact to admin");
                        }
                        ShowToastDialog.closeLoader();
                      } else {
                        ShowToastDialog.showToast(
                            "Upload all required documents.".tr);
                      }
                    },
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Your Documents'.tr,
                      style: GoogleFonts.inter(
                        color: AppThemData.grey950,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26, top: 6),
                      child: Text(
                        'Securely upload required documents for identity verification and account authentication'
                            .tr,
                        style: GoogleFonts.inter(
                          color: AppThemData.grey500,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/icon/gif_verify_details.gif",
                        height: 76.0,
                        width: 76.0,
                      ),
                    ),
                    const SizedBox(height: 28),
                    InkWell(
                      onTap: () {
                        Get.to(UpdateVehicleDetailsView(
                          isUploaded:
                              controller.userModel.value.driverVehicleDetails !=
                                  null,
                        ));
                      },
                      child: Obx(
                        () => Container(
                          padding:
                              controller.userModel.value.driverVehicleDetails !=
                                      null
                                  ? const EdgeInsets.all(16)
                                  : EdgeInsets.zero,
                          decoration: ShapeDecoration(
                            color: controller
                                        .userModel.value.driverVehicleDetails !=
                                    null
                                ? AppThemData.primary50
                                : AppThemData.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: controller.userModel.value
                                            .driverVehicleDetails ==
                                        null
                                    ? const EdgeInsets.only(top: 16, bottom: 16)
                                    : EdgeInsets.zero,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    controller.userModel.value
                                                .driverVehicleDetails !=
                                            null
                                        ? SvgPicture.asset(
                                            "assets/icon/ic_vehicle_details.svg")
                                        : Icon(
                                            Icons.add,
                                            color: AppThemData.primary500,
                                          ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.userModel.value
                                                        .driverVehicleDetails !=
                                                    null
                                                ? 'Vehicle Details'.tr
                                                : 'Add Your Vehicle Details'.tr,
                                            style: GoogleFonts.inter(
                                              color: AppThemData.grey950,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (controller.userModel.value
                                                  .driverVehicleDetails !=
                                              null) ...{
                                            Row(
                                              children: [
                                                Text(
                                                  (controller
                                                              .userModel
                                                              .value
                                                              .driverVehicleDetails!
                                                              .isVerified ??
                                                          false)
                                                      ? 'Verified'.tr
                                                      : 'Not Verified'.tr,
                                                  style: GoogleFonts.inter(
                                                    color: (controller
                                                                .userModel
                                                                .value
                                                                .driverVehicleDetails!
                                                                .isVerified ??
                                                            false)
                                                        ? AppThemData.success500
                                                        : AppThemData.danger500,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Container(
                                                    width: 16,
                                                    height: 16,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 7),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: (controller
                                                                  .userModel
                                                                  .value
                                                                  .driverVehicleDetails!
                                                                  .isVerified ??
                                                              false)
                                                          ? AppThemData
                                                              .success500
                                                          : AppThemData
                                                              .danger500,
                                                    ),
                                                    child: Icon(
                                                      (controller
                                                                  .userModel
                                                                  .value
                                                                  .driverVehicleDetails!
                                                                  .isVerified ??
                                                              false)
                                                          ? Icons.check
                                                          : Icons.close,
                                                      size: 12,
                                                      color: AppThemData.white,
                                                    ))
                                              ],
                                            )
                                          },
                                        ],
                                      ),
                                    ),
                                    if (controller.userModel.value
                                            .driverVehicleDetails !=
                                        null) ...{
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 20,
                                        color: AppThemData.grey500,
                                      )
                                    }
                                  ],
                                ),
                              ),
                              if (controller
                                      .userModel.value.driverVehicleDetails ==
                                  null) ...{
                                const Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Divider(
                                    color: AppThemData.grey100,
                                  ),
                                )
                              }
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => ListView.builder(
                        itemCount: controller.documentList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isUploaded = controller.checkUploadedData(
                              controller.documentList[index].id);
                          bool isVerified = controller.checkVerifiedData(
                              controller.documentList[index].id);
                          return InkWell(
                            onTap: () {
                              Get.to(UploadDocumentsView(
                                document: controller.documentList[index],
                                isUploaded: isUploaded,
                              ));
                            },
                            child: Container(
                              padding: isUploaded
                                  ? const EdgeInsets.all(16)
                                  : EdgeInsets.zero,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: ShapeDecoration(
                                color: isUploaded
                                    ? AppThemData.primary50
                                    : AppThemData.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: isUploaded
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.only(
                                            top: 16, bottom: 16),
                                    child: Row(
                                      children: [
                                        isUploaded
                                            ? SvgPicture.asset(
                                                "assets/icon/ic_vehicle_details.svg")
                                            : SvgPicture.asset(
                                                "assets/icon/ic_upload_document.svg"),
                                        const SizedBox(width: 18),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isUploaded
                                                    ? controller
                                                        .documentList[index]
                                                        .title
                                                    : "Upload ${controller.documentList[index].title}",
                                                style: GoogleFonts.inter(
                                                  color: AppThemData.grey950,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              if (isUploaded) ...{
                                                Row(
                                                  children: [
                                                    Text(
                                                      isVerified
                                                          ? 'Verified'.tr
                                                          : 'Not Verified'.tr,
                                                      style: GoogleFonts.inter(
                                                        color: isVerified
                                                            ? AppThemData
                                                                .success500
                                                            : AppThemData
                                                                .danger500,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: 16,
                                                        height: 16,
                                                        margin: const EdgeInsets
                                                            .only(left: 7),
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          color: isVerified
                                                              ? AppThemData
                                                                  .success500
                                                              : AppThemData
                                                                  .danger500,
                                                        ),
                                                        child: Icon(
                                                          isVerified
                                                              ? Icons.check
                                                              : Icons.close,
                                                          size: 12,
                                                          color:
                                                              AppThemData.white,
                                                        ))
                                                  ],
                                                )
                                              },
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 20,
                                          color: AppThemData.grey500,
                                        )
                                      ],
                                    ),
                                  ),
                                  if (!isUploaded) ...{
                                    const Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Divider(
                                        color: AppThemData.grey100,
                                      ),
                                    )
                                  }
                                ],
                              ),
                            ),
                          );
                        },
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
