import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/modules/my_wallet/controllers/my_wallet_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../models/withdraw_model.dart';

class WithdrawalDialogView extends StatelessWidget {
  const WithdrawalDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: GetX<MyWalletController>(
        init: MyWalletController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 25),
                    decoration: ShapeDecoration(
                      color: themeChange.isDarkTheme() ? AppThemData.grey700 : AppThemData.grey200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Withdraw Money'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                        ),
                      )
                    ],
                  ),
                  AutoSizeTextField(
                    controller: controller.withdrawalAmountController,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    fullwidth: false,
                    // minWidth: 100,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        suffixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 20, minHeight: 20, minWidth: 20),
                        suffixIcon: SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icon/ic_edit.svg",
                            )),
                        contentPadding: const EdgeInsets.all(20)),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: controller.formKey.value,
                    child: TextFieldWithTitle(
                      validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      title: "Note (Optional) :".tr,
                      hintText: "Enter Note".tr,
                      keyboardType: TextInputType.text,
                      controller: controller.withdrawalNoteController,
                      isEnable: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Bank'.tr,
                          style: GoogleFonts.inter(
                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Divider(),
                      );
                    },
                    itemCount: controller.bankDetailsList.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => Container(
                          transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                          child: RadioListTile(
                            value: controller.bankDetailsList[index],
                            groupValue: controller.selectedBankMethod.value,
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppThemData.primary500,
                            title: SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.bankDetailsList[index].bankName.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    controller.bankDetailsList[index].accountNumber.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    controller.bankDetailsList[index].holderName.toString(),
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedBankMethod.value = controller.bankDetailsList[index];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  RoundShapeButton(
                    title: "Withdraw".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () async {
                      if (controller.formKey.value.currentState!.validate()) {
                        if (double.parse(controller.userModel.value.walletAmount.toString()) <= double.parse(Constant.minimumAmountToWithdrawal.toString())) {
                          ShowToastDialog.showToast("Insufficient balance".tr);
                        } else {
                          ShowToastDialog.showLoader("Please wait..".tr);
                          if (controller.withdrawalAmountController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter amount".tr);
                          } else if (double.parse(controller.userModel.value.walletAmount.toString()) < double.parse(controller.withdrawalAmountController.value.text)) {
                            ShowToastDialog.showToast("Insufficient balance".tr);
                          } else if (double.parse(Constant.minimumAmountToWithdrawal) > double.parse(controller.withdrawalAmountController.value.text)) {
                            ShowToastDialog.showToast(
                                "${"Withdraw amount must be greater or equal to ".tr}${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}");
                          } else {
                            ShowToastDialog.showLoader("Please wait".tr);
                            WithdrawModel withdrawModel = WithdrawModel();
                            withdrawModel.id = Constant.getUuid();
                            withdrawModel.driverId = FireStoreUtils.getCurrentUid();
                            withdrawModel.paymentStatus = "Pending";
                            withdrawModel.amount = controller.withdrawalAmountController.value.text;
                            withdrawModel.note = controller.withdrawalNoteController.value.text;
                            withdrawModel.createdDate = Timestamp.now();
                            withdrawModel.bankDetails = controller.selectedBankMethod.value;
                            await FireStoreUtils.updateDriverUserWallet(amount: "-${controller.withdrawalAmountController.value.text}");

                            await FireStoreUtils.setWithdrawRequest(withdrawModel).then((value) {
                              controller.getProfileData();
                              controller.withdrawalAmountController.value.text != "";
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast("Request sent to admin".tr);
                              Get.back();
                            });
                          }
                          controller.getWalletTransactions();
                        }
                      } else {
                        ShowToastDialog.showToast("Enter Note".tr);
                      }
                    },
                    size: const Size(210, 52),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
