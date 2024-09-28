import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:driver/app/models/support_reason_model.dart';
import 'package:driver/app/modules/create_support_ticket/controllers/create_support_ticket_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateSupportTicketView extends GetView<CreateSupportTicketController> {
  const CreateSupportTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CreateSupportTicketController>(
        init: CreateSupportTicketController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(
              title: "Create Ticket".tr,
              bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            ),
            body: Form(
              key: controller.formKey.value,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title".tr,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -06.0, 0.0),
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: controller.selectedSupportTitle.value.id == null ? null : controller.selectedSupportTitle.value,
                          items: controller.supportReasonList.map((item) {
                            return DropdownMenuItem<SupportReasonModel>(
                                value: item,
                                child: Text(
                                  item.reason.toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontWeight: FontWeight.w400),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedSupportTitle.value = value!;
                          },
                          icon: SvgPicture.asset("assets/icon/ic_CaretDown.svg"),
                          elevation: 0,
                          decoration: const InputDecoration(
                            prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            // hintText: "Select Title",
                            // hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                          ),
                          hint: Text(
                            "Select Title".tr,
                            style: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Subject".tr,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -06.0, 0.0),
                        child: TextFormField(
                          cursorColor:themeChange.isDarkTheme() ? AppThemData.white :  Colors.black,
                          controller: controller.subjectController.value,
                          // keyboardType: keyboardType,
                          // inputFormatters: inputFormatters,
                          enabled: true,
                          validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            hintText: "Enter Subject".tr,
                            hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Description".tr,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -06.0, 0.0),
                        child: TextFormField(
                          cursorColor:themeChange.isDarkTheme() ? AppThemData.white :  Colors.black,
                          controller: controller.descriptionController.value,
                          // keyboardType: keyboardType,
                          // inputFormatters: inputFormatters,
                          enabled: true,
                          validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
                            hintText: "Enter Description".tr,
                            hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (controller.supportImages.isNotEmpty)
                          ? InkWell(
                              onTap: () {
                                controller.pickMultipleImages();
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                dashPattern: const [6, 6, 6, 6],
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                child: Container(
                                  height: Responsive.height(20, context),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      // color: AppColors.primary.withOpacity(0.05),
                                      color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      child: GridView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: controller.supportImages.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Constant.hasValidUrl(controller.supportImages[index]) == false
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.file(
                                                        File(controller.supportImages[index]),
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: controller.supportImages[index].toString(),
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.fill,
                                                    ),
                                              Positioned(
                                                  child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    controller.supportImages.remove(controller.supportImages[index]);
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: themeChange.isDarkTheme()
                                                        ? const Color(0xff4B4B4B).withOpacity(0.8)
                                                        : const Color(0xffF8F8F8).withOpacity(0.8),
                                                    maxRadius: 10,
                                                    child: Icon(
                                                      Icons.cancel_outlined,
                                                      size: 14,
                                                      color: themeChange.isDarkTheme() ? AppThemData.grey200 : AppThemData.grey800,
                                                    ),
                                                  ),
                                                ),
                                              ))
                                            ],
                                          );
                                        },
                                      )),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                controller.pickMultipleImages();
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                dashPattern: const [6, 6, 6, 6],
                                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                child: Container(
                                  height: Responsive.height(20, context),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      // color: AppColors.primary.withOpacity(0.05),
                                      color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/icon/ic_image.svg"),
                                      Text(
                                        "choose Image".tr,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: RoundShapeButton(
                    title: "Save".tr,
                    buttonColor: AppThemData.primary500,
                    buttonTextColor: AppThemData.black,
                    onTap: () {
                      if (controller.formKey.value.currentState!.validate()) {
                        if (controller.selectedSupportTitle.value.id == null || controller.selectedSupportTitle.value.id!.isEmpty) {
                          ShowToastDialog.showToast("Please Select Title".tr);
                        } else if (controller.supportImages.isEmpty) {
                          ShowToastDialog.showToast("Please Choose the Image".tr);
                        } else {
                          controller.saveSupportTicket();
                        }
                      }
                    },
                    size: const Size(208, 52))),
          );
        });
  }
}
