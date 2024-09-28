import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/home/views/widgets/chart_view.dart';
import 'package:driver/app/modules/home/views/widgets/drawer_view.dart';
import 'package:driver/app/modules/home/views/widgets/new_ride_view.dart';
import 'package:driver/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:driver/app/modules/language/views/language_view.dart';
import 'package:driver/app/modules/my_bank/views/my_bank_view.dart';
import 'package:driver/app/modules/my_rides/views/my_rides_view.dart';
import 'package:driver/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:driver/app/modules/notifications/views/notifications_view.dart';
import 'package:driver/app/modules/support_screen/views/support_screen_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/star_rating.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
        init: HomeController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBar(
              shape: Border(bottom: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icon/logo_only.svg"),
                  const SizedBox(width: 10),
                  Text(
                    'MyTaxi'.tr,
                    style: GoogleFonts.inter(
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const NotificationsView());
                    },
                    icon: const Icon(Icons.notifications_none_rounded))
              ],
            ),
            drawer: const DrawerView(),
            body: Obx(
              () => controller.drawerIndex.value == 1
                  ? MyRidesView()
                  : controller.drawerIndex.value == 2
                      ? const MyWalletView()
                      : controller.drawerIndex.value == 3
                          ? const MyBankView()
                          : controller.drawerIndex.value == 4
                              ? const VerifyDocumentsView(
                                  isFromDrawer: true,
                                )
                              : controller.drawerIndex.value == 5
                                  ? const SupportScreenView()
                                  : controller.drawerIndex.value == 6
                                      ? HtmlViewScreenView(title: "Privacy & Policy", htmlData: Constant.privacyPolicy)
                                      : controller.drawerIndex.value == 7
                                          ? HtmlViewScreenView(title: "Terms & Condition", htmlData: Constant.termsAndConditions)
                                          : controller.drawerIndex.value == 8
                                              ? const LanguageView()
                                              : controller.isLoading.value
                                                  ? Constant.loader()
                                                  : SingleChildScrollView(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: Responsive.width(100, context),
                                                              // height: 100,
                                                              padding: const EdgeInsets.all(16),
                                                              margin: const EdgeInsets.only(bottom: 20),
                                                              decoration: ShapeDecoration(
                                                                image: const DecorationImage(
                                                                    image: AssetImage("assets/images/top_banner_background.png"),
                                                                    fit: BoxFit.cover),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(16),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        'Total Earnings'.tr,
                                                                        style: GoogleFonts.inter(
                                                                          color: AppThemData.white,
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: Responsive.width(60, context),
                                                                        margin: const EdgeInsets.only(top: 6),
                                                                        child: Text(
                                                                          Constant.amountShow(
                                                                              amount: (controller.userModel.value.totalEarning ?? '0.0')
                                                                                  .toString()),
                                                                          style: GoogleFonts.inter(
                                                                            color: AppThemData.grey50,
                                                                            fontSize: 28,
                                                                            fontWeight: FontWeight.w700,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SvgPicture.asset(
                                                                    "assets/icon/ic_hand_currency.svg",
                                                                    width: 52,
                                                                    height: 52,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              'Total Rides'.tr,
                                                              style: GoogleFonts.inter(
                                                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 16),
                                                            ChartView(themeChange: themeChange),
                                                            const SizedBox(height: 20),
                                                            Container(
                                                              width: double.infinity,
                                                              padding: const EdgeInsets.all(16),
                                                              decoration: ShapeDecoration(
                                                                color: themeChange.isDarkTheme()
                                                                    ? AppThemData.secondary950
                                                                    : AppThemData.secondary50,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    'Note'.tr,
                                                                    style: GoogleFonts.inter(
                                                                      color: themeChange.isDarkTheme()
                                                                          ? AppThemData.grey25
                                                                          : AppThemData.grey950,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 8),
                                                                  Text(
                                                                    'A ${Constant.adminCommission!.isFix == true ? Constant.amountToShow(amount: Constant.adminCommission!.value) : "${Constant.adminCommission!.value}%"} commission fee will be deducted from each ride payment for administrative purposes.'
                                                                        .tr,
                                                                    style: GoogleFonts.inter(
                                                                      color: themeChange.isDarkTheme()
                                                                          ? AppThemData.grey25
                                                                          : AppThemData.grey950,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(height: 16),
                                                            Visibility(
                                                              visible: controller.isOnline.value,
                                                              child: StreamBuilder<List<BookingModel>>(
                                                                  stream: FireStoreUtils().getBookings(Constant.currentLocation!.latitude,
                                                                      Constant.currentLocation!.longitude),
                                                                  builder: (context, snapshot) {
                                                                    log("State : ${snapshot.connectionState}");
                                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                                      return Constant.loader();
                                                                    }
                                                                    if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                                                                      return Container();
                                                                    } else {
                                                                      BookingModel bookingModel = snapshot.data!.first;
                                                                      return Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'New Ride'.tr,
                                                                            style: GoogleFonts.inter(
                                                                              color: themeChange.isDarkTheme()
                                                                                  ? AppThemData.grey25
                                                                                  : AppThemData.grey950,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                              height: 0.08,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          NewRideView(
                                                                            bookingModel: bookingModel,
                                                                          ),
                                                                          const SizedBox(height: 4),
                                                                        ],
                                                                      );
                                                                    }
                                                                  }),
                                                            ),
                                                            Obx(
                                                              () => Visibility(
                                                                visible: controller.isOnline.value,
                                                                child: StreamBuilder<List<BookingModel>>(
                                                                    stream: FireStoreUtils().getHomeOngoingBookings(),
                                                                    builder: (context, snapshot) {
                                                                      log("State : ${snapshot.connectionState}");
                                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                                        return Constant.loader();
                                                                      }
                                                                      if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                                                                        return Container();
                                                                      } else {
                                                                        BookingModel bookingModel = snapshot.data!.first;
                                                                        return Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Ongoing Ride'.tr,
                                                                              style: GoogleFonts.inter(
                                                                                color: themeChange.isDarkTheme()
                                                                                    ? AppThemData.grey25
                                                                                    : AppThemData.grey950,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 20),
                                                                            NewRideView(
                                                                              bookingModel: bookingModel,
                                                                            ),
                                                                            const SizedBox(height: 4),
                                                                          ],
                                                                        );
                                                                      }
                                                                    }),
                                                              ),
                                                            ),
                                                            Obx(
                                                              () => Visibility(
                                                                  visible: controller.isOnline.value == false,
                                                                  child: Column(
                                                                    children: [
                                                                      goOnlineDialog(
                                                                        title: "You're Now Offline",
                                                                        descriptions:
                                                                            "Please change your status to online to access all features. When offline, you won't be able to access any functionalities.",
                                                                        img: SvgPicture.asset(
                                                                          "assets/icon/ic_offline.svg",
                                                                          height: 58,
                                                                          width: 58,
                                                                        ),
                                                                        onClick: () async {
                                                                          await FireStoreUtils.updateDriverUserOnline(true);
                                                                          controller.isOnline.value = true;
                                                                          controller.updateCurrentLocation();
                                                                        },
                                                                        string: "Go Online".tr,
                                                                        themeChange: themeChange,
                                                                        context: context,
                                                                      ),
                                                                      const SizedBox(height: 20),
                                                                    ],
                                                                  )),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'Customer Reviews'.tr,
                                                                  style: GoogleFonts.inter(
                                                                    color: themeChange.isDarkTheme()
                                                                        ? AppThemData.grey25
                                                                        : AppThemData.grey950,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 0.08,
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed(Routes.REVIEW_SCREEN);
                                                                  },
                                                                  child: Text(
                                                                    'View all'.tr,
                                                                    style: GoogleFonts.inter(
                                                                      color: AppThemData.primary500,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(height: 20),
                                                            if (controller.reviewList.isEmpty) ...{
                                                              const SizedBox(height: 20),
                                                              Center(
                                                                child: Text(
                                                                  'No Customer review found'.tr,
                                                                  style: GoogleFonts.inter(
                                                                    color: themeChange.isDarkTheme()
                                                                        ? AppThemData.grey25
                                                                        : AppThemData.grey950,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w200,
                                                                    height: 0.08,
                                                                  ),
                                                                ),
                                                              ),
                                                            },
                                                            SizedBox(
                                                              height: 164,
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    controller.reviewList.length >= 5 ? 5 : controller.reviewList.length,
                                                                scrollDirection: Axis.horizontal,
                                                                itemBuilder: (context, index) {
                                                                  return Container(
                                                                    width: 210,
                                                                    padding: const EdgeInsets.all(16),
                                                                    margin: const EdgeInsets.only(right: 16),
                                                                    decoration: ShapeDecoration(
                                                                      color: themeChange.isDarkTheme()
                                                                          ? controller.colorDark[index % 4]
                                                                          : controller.color[index % 4],
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        FutureBuilder<UserModel?>(
                                                                          future: FireStoreUtils.getUserProfile(
                                                                              controller.reviewList[index].customerId.toString()),
                                                                          builder:
                                                                              (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return const SizedBox();
                                                                              default:
                                                                                if (snapshot.hasError) {
                                                                                  return Container(
                                                                                    width: 50,
                                                                                    height: 50,
                                                                                    clipBehavior: Clip.antiAlias,
                                                                                    decoration: ShapeDecoration(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(200),
                                                                                      ),
                                                                                      color: AppThemData.white,
                                                                                      image: const DecorationImage(
                                                                                        image: NetworkImage(Constant.profileConstant),
                                                                                        fit: BoxFit.fill,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  UserModel? userModel = snapshot.data;
                                                                                  return ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(60),
                                                                                    child: CachedNetworkImage(
                                                                                      height: 50,
                                                                                      width: 50,
                                                                                      fit: BoxFit.cover,
                                                                                      imageUrl: userModel!.profilePic.toString(),
                                                                                      errorWidget: (context, url, error) {
                                                                                        return Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          clipBehavior: Clip.antiAlias,
                                                                                          decoration: ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(200),
                                                                                            ),
                                                                                            color: AppThemData.white,
                                                                                            image: const DecorationImage(
                                                                                              image: NetworkImage(Constant.profileConstant),
                                                                                              fit: BoxFit.fill,
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                }
                                                                            }
                                                                          },
                                                                        ),
                                                                        FutureBuilder<UserModel?>(
                                                                          future: FireStoreUtils.getUserProfile(
                                                                              controller.reviewList[index].customerId.toString()),
                                                                          builder:
                                                                              (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.waiting:
                                                                                return const SizedBox();
                                                                              default:
                                                                                if (snapshot.hasError) {
                                                                                  return Text(
                                                                                    'Error: ${snapshot.error}',
                                                                                  );
                                                                                } else {
                                                                                  UserModel? userModel = snapshot.data;
                                                                                  return Text(
                                                                                    userModel!.fullName.toString(),
                                                                                    style: GoogleFonts.inter(
                                                                                      color: themeChange.isDarkTheme()
                                                                                          ? AppThemData.grey25
                                                                                          : AppThemData.grey950,
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                            }
                                                                          },
                                                                        ),
                                                                        const SizedBox(height: 4),
                                                                        StarRating(
                                                                          onRatingChanged: (rating) {},
                                                                          color: AppThemData.warning500,
                                                                          starCount: 5,
                                                                          rating: 4,
                                                                        ),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                          controller.reviewList[index].comment.toString(),
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: GoogleFonts.inter(
                                                                            color: themeChange.isDarkTheme()
                                                                                ? AppThemData.grey25
                                                                                : AppThemData.grey950,
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
            ),
          );
        });
  }
}

goOnlineDialog({
  required BuildContext context,
  required String title,
  required descriptions,
  required string,
  required Widget img,
  required Function() onClick,
  required DarkThemeProvider themeChange,
  Color? buttonColor,
  Color? buttonTextColor,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle, color: themeChange.isDarkTheme() ? Colors.black : Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        img,
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: title.isNotEmpty,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: descriptions.isNotEmpty,
          child: Text(
            descriptions,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  onClick();
                },
                child: Container(
                  width: Responsive.width(100, context),
                  height: 45,
                  decoration: ShapeDecoration(
                    color: buttonColor ?? AppThemData.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        string.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: buttonTextColor ?? AppThemData.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
