import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/modules/my_bank/controllers/my_bank_controller.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class AddBankView extends GetView<MyBankController> {
  const AddBankView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyBankController(),
      builder: (controller) {
        return Scaffold(
            appBar: AppBarWithBorder(title: "Bank Details".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundShapeButton(
                  title: "Submit".tr,
                  buttonColor: AppThemData.primary500,
                  buttonTextColor: AppThemData.black,
                  onTap: () async {
                    if (controller.formKey.value.currentState!.validate()) {
                      if (controller.editingId.value != "") {
                        controller.updateBankDetail();
                      } else {
                        controller.setBankDetails();
                      }
                      controller.getData();
                      Get.back();
                    }
                  },
                  size: const Size(210, 52),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Bank Holder Name".tr,
                        hintText: "Enter Bank Holder Name".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.bankHolderNameController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Bank Account Number".tr,
                        hintText: "Enter bank account number".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.bankAccountNumberController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Swift Code".tr,
                        hintText: "Enter Swift Code".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.swiftCodeController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "IFSC Code".tr,
                        hintText: "Enter IFSC Code".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.ifscCodeController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Bank Name".tr,
                        hintText: "Enter Bank Name".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.bankNameController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Bank Branch City".tr,
                        hintText: "Enter Bank Branch City".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.bankBranchCityController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithTitle(
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        title: "Bank Branch Country".tr,
                        hintText: "Enter Bank Branch Country".tr,
                        keyboardType: TextInputType.text,
                        controller: controller.bankBranchCountryController,
                        isEnable: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
