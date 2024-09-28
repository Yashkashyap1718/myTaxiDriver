import 'package:driver/app/modules/support_screen/controllers/support_screen_controller.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SupportScreenView extends GetView<SupportScreenController> {
  const SupportScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SupportScreenController>(
        init: SupportScreenController(),
        builder: (controller) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    Get.toNamed(Routes.CREATE_SUPPORT_TICKET)!.then((value) {
                      if (value == true) {
                        controller.getData();
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(52)),
                  backgroundColor: AppThemData.primary500,
                  child: const Icon(
                    Icons.add,
                    size: 28,
                    color: AppThemData.white,
                  )),
              body: (controller.isLoading.value)
                  ? Constant.loader()
                  : (controller.supportTicketList.isEmpty)
                      ? Constant.showEmptyView(message: "No Ticket Found".tr)
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.supportTicketList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.SUPPORT_TICKET_DETAILS,
                                    arguments: {"supportTicket": controller.supportTicketList[index]});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
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
                                          controller.supportTicketList[index].title.toString(),
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                        )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          controller.supportTicketList[index].status.toString() == "pending"
                                              ? "Pending"
                                              : controller.supportTicketList[index].status.toString() == "accepted"
                                                  ? "Accepted"
                                                  : "Rejected",
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: (controller.supportTicketList[index].status.toString() == "pending"
                                                ? AppThemData.primary400
                                                : (controller.supportTicketList[index].status.toString() == "accepted"
                                                    ? AppThemData.success500
                                                    : AppThemData.error08)),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      controller.supportTicketList[index].description.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${Constant.timestampToDate(controller.supportTicketList[index].createAt!)}, ",
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600),
                                        ),
                                        Text(
                                          Constant.timestampToTime12Hour(controller.supportTicketList[index].createAt!),
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: themeChange.isDarkTheme() ? AppThemData.grey300 : AppThemData.grey600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
        });
  }
}
