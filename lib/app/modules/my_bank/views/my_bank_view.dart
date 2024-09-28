import 'package:driver/app/models/bank_detail_model.dart';
import 'package:driver/app/modules/add_bank/views/add_bank_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/my_bank_controller.dart';

class MyBankView extends GetView<MyBankController> {
  const MyBankView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<MyBankController>(
      init: MyBankController(),
      builder: (controller) {
        return Scaffold(
          // appBar: AppBarWithBorder(title: "My Bank".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundShapeButton(
                title: "Add Bank".tr,
                buttonColor: AppThemData.primary500,
                buttonTextColor: AppThemData.black,
                onTap: () async {
                  Get.to(const AddBankView());
                },
                size: const Size(210, 52),
              ),
            ],
          ),
          body: controller.isLoading.value
              ? Center(
                  child: Constant.loader(),
                )
              : controller.bankDetailsList.isEmpty
                  ? Center(
                      child: Text(
                        'No Data available'.tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.bankDetailsList.length,
                      itemBuilder: (context, index) {
                        BankDetailsModel bankDetailsModel = controller.bankDetailsList[index];
                        return Container(
                          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          decoration: BoxDecoration(
                            color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.grey50,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                height: 70,
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          bankDetailsModel.bankName.toString(),
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          bankDetailsModel.accountNumber.toString(),
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          bankDetailsModel.holderName.toString(),
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton(
                                        itemBuilder: (BuildContext bc) {
                                          return [
                                            PopupMenuItem<String>(
                                              height: 30,
                                              value: "Edit".tr,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Edit".tr,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              height: 30,
                                              value: "Delete".tr,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Delete".tr,
                                                    style: GoogleFonts.inter(
                                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ];
                                        },
                                        onSelected: (value) {
                                          if (value == "Edit") {
                                            controller.editingId.value = bankDetailsModel.id.toString();
                                            controller.bankHolderNameController.text = bankDetailsModel.holderName.toString();
                                            controller.bankAccountNumberController.text = bankDetailsModel.accountNumber.toString();
                                            controller.swiftCodeController.text = bankDetailsModel.swiftCode.toString();
                                            controller.ifscCodeController.text = bankDetailsModel.ifscCode.toString();
                                            controller.bankNameController.text = bankDetailsModel.bankName.toString();
                                            controller.bankBranchCityController.text = bankDetailsModel.branchCity.toString();
                                            controller.bankBranchCountryController.text = bankDetailsModel.branchCountry.toString();
                                            Get.to(const AddBankView());
                                          } else {
                                            controller.deleteBankDetails(controller.bankDetailsList[index]);
                                          }
                                        },
                                        child: SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: SvgPicture.asset(
                                              "assets/icon/ic_three_dot.svg",
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
        );
      },
    );
  }
}
