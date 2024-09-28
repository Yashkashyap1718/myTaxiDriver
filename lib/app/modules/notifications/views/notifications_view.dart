import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          appBar: AppBarWithBorder(
            title: "Notifications".tr,
            bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          ),
          body: Obx(
            () => controller.isLoading.value
                ? Constant.loader()
                : controller.notificationList.isEmpty
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
                        itemCount: controller.notificationList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: Responsive.width(100, context),
                            padding: const EdgeInsets.all(16),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.notificationList[index].title.toString(),
                                        style: GoogleFonts.inter(
                                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        ShowToastDialog.showLoader("Please wait".tr);
                                        controller.removeNotification(controller.notificationList[index].id.toString());
                                        ShowToastDialog.closeLoader();
                                      },
                                      color: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                                      position: PopupMenuPosition.under,
                                      elevation: 4,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      itemBuilder: (BuildContext context) {
                                        return {'Delete'}.map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset("assets/icon/ic_delete.svg"),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    choice,
                                                    style: GoogleFonts.inter(
                                                      color: AppThemData.danger500,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.notificationList[index].description.toString(),
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }
}
