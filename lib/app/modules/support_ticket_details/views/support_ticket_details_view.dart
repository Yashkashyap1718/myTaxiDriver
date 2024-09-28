import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/modules/support_ticket_details/controllers/support_ticket_details_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SupportTicketDetailsView extends GetView<SupportTicketDetailsController> {
  const SupportTicketDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SupportTicketDetailsController>(
        init: SupportTicketDetailsController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBarWithBorder(
                title: 'Id #${controller.supportTicketModel.value.id}',
                bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            body: (controller.isLoading.value)
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      controller.supportTicketModel.value.title.toString(),
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                    )),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      controller.supportTicketModel.value.status.toString() == "pending"
                                          ? "Pending"
                                          : controller.supportTicketModel.value.status.toString() == "accepted"
                                              ? "Accepted"
                                              : "Rejected",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: (controller.supportTicketModel.value.status.toString() == "pending"
                                            ? AppThemData.primary400
                                            : (controller.supportTicketModel.value.status.toString() == "accepted"
                                                ? AppThemData.success500
                                                : AppThemData.error08)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  controller.supportTicketModel.value.subject.toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  controller.supportTicketModel.value.description.toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500),
                                ),
                                if (controller.supportTicketModel.value.attachments!.isNotEmpty)
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        height: 80,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: controller.supportTicketModel.value.attachments!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(right: 8),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl: controller.supportTicketModel.value.attachments![index].toString(),
                                                    fit: BoxFit.fill,
                                                    height: 80,
                                                    width: 80,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                                      child: CircularProgressIndicator(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Note by Admin".tr,
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                (controller.supportTicketModel.value.notes!.isEmpty)
                                    ? Center(
                                        child: Text(
                                          "No Notes".tr,
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                        ),
                                      )
                                    : Text(
                                        controller.supportTicketModel.value.notes.toString(),
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
