import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:driver/app/modules/my_wallet/controllers/my_wallet_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddMoneyDialogView extends StatelessWidget {
  const AddMoneyDialogView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: GetBuilder(
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
                            'Add Money'.tr,
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
                      controller: controller.amountController,
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
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.paypal!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paypal.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.paypal!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.paypal!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.strip!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_stripe.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.strip!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.strip!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.razorpay!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_razorpay.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.razorpay!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.razorpay!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.flutterWave!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_flutterwave.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.flutterWave!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.flutterWave!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.payStack != null && controller.paymentModel.value.payStack!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payStack!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_paystack.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payStack!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payStack!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.mercadoPago!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_marcadopago.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.mercadoPago!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.mercadoPago!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentModel.value.payFast != null && controller.paymentModel.value.payFast!.isActive == true,
                            child: Column(
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                  child: RadioListTile(
                                    value: Constant.paymentModel!.payFast!.name.toString(),
                                    groupValue: controller.selectedPaymentMethod.value,
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppThemData.primary500,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/ig_payfast.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          Constant.paymentModel!.payFast!.name ?? "",
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (value) {
                                      controller.selectedPaymentMethod.value = Constant.paymentModel!.payFast!.name.toString();
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 40, right: 10),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                  child: const Divider(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    RoundShapeButton(
                      title: "Add",
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () async {
                        if (controller.selectedPaymentMethod.value.isNotEmpty) {
                          if (controller.amountController.value.text.isNotEmpty) {
                            if (double.parse(controller.amountController.value.text) >= double.parse(Constant.minimumAmountToDeposit.toString())) {
                              ShowToastDialog.showLoader("Please wait");
                              if (controller.selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name) {
                                await controller.paypalPaymentSheet(controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.strip!.name) {
                                await controller.stripeMakePayment(amount: controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name) {
                                await controller.razorpayMakePayment(amount: controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.flutterWave!.name) {
                                await controller.flutterWaveInitiatePayment(context: context, amount: controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name) {
                                await controller.payStackPayment(controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.mercadoPago!.name) {
                                await controller.mercadoPagoMakePayment(context: context, amount: controller.amountController.text);
                                Get.back();
                              } else if (controller.selectedPaymentMethod.value == Constant.paymentModel!.payFast!.name) {
                                await controller.payFastPayment(context: context, amount: controller.amountController.text);
                                Get.back();
                              }
                              ShowToastDialog.closeLoader();
                            } else {
                              ShowToastDialog.showToast("${"Please Enter minimum amount of".tr} ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}");
                            }
                          } else {
                            ShowToastDialog.showToast("Please enter amount".tr);
                          }
                        } else {
                          ShowToastDialog.showToast("Please select payment type".tr);
                        }
                      },
                      size: const Size(210, 52),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
