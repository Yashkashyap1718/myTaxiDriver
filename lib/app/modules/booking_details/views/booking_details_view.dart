// ignore_for_file: use_build_context_synchronously


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/tax_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/booking_details/widget/price_row_view.dart';
import 'package:driver/app/modules/chat_screen/views/chat_screen_view.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/reason_for_cancel/views/reason_for_cancel_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/title_view.dart';
import 'package:driver/extension/date_time_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/booking_details_controller.dart';

class BookingDetailsView extends StatelessWidget {
  const BookingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BookingDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            appBar: AppBarWithBorder(title: "Ride Detail".tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.bookingModel.value.bookingStatus == BookingStatus.bookingPlaced &&
                      !controller.bookingModel.value.rejectedDriverId!.contains(FireStoreUtils.getCurrentUid())) ...{
                    RoundShapeButton(
                      title: "Cancel Ride".tr,
                      buttonColor: AppThemData.grey50,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                  themeChange: themeChange,
                                  title: "Cancel Ride".tr,
                                  descriptions: "Are you sure you want cancel this ride?".tr,
                                  positiveString: "Cancel Ride".tr,
                                  negativeString: "Cancel".tr,
                                  positiveClick: () async {
                                    List rejectedId = controller.bookingModel.value.rejectedDriverId ?? [];
                                    rejectedId.add(FireStoreUtils.getCurrentUid());
                                    controller.bookingModel.value.bookingStatus = BookingStatus.bookingRejected;
                                    controller.bookingModel.value.rejectedDriverId = rejectedId;
                                    controller.bookingModel.value.updateAt = Timestamp.now();
                                    FireStoreUtils.setBooking(controller.bookingModel.value).then((value) async {
                                      if (value == true) {
                                        controller.getBookingDetails();
                                        ShowToastDialog.showToast("Ride cancelled successfully!");
                                        // DriverUserModel? driverModel =
                                        //     await FireStoreUtils.getDriverUserProfile(controller.bookingModel.value.driverId.toString());
                                        UserModel? receiverUserModel =
                                            await FireStoreUtils.getUserProfile(controller.bookingModel.value.customerId.toString());
                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.bookingModel.value.id};

                                        await SendNotification.sendOneNotification(
                                            type: "order",
                                            token: receiverUserModel!.fcmToken.toString(),
                                            title: 'Your Ride is Rejected'.tr,
                                            customerId: receiverUserModel.id,
                                            senderId: FireStoreUtils.getCurrentUid(),
                                            bookingId: controller.bookingModel.value.id.toString(),
                                            driverId: controller.bookingModel.value.driverId.toString(),
                                            body:
                                                'Your ride #${controller.bookingModel.value.id.toString().substring(0, 4)} has been Rejected by Driver.',
                                            // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                            payload: playLoad);

                                        controller.getBookingDetails();
                                        Navigator.pop(context);
                                        // Get.to(() => const HomeView());
                                      } else {
                                        ShowToastDialog.showToast("Something went wrong!");
                                        Navigator.pop(context);
                                      }
                                    });
                                    controller.getBookingDetails();
                                    Navigator.pop(context);
                                  },
                                  negativeClick: () {
                                    Navigator.pop(context);
                                  },
                                  img: Image.asset(
                                    "assets/icon/ic_close.png",
                                    height: 58,
                                    width: 58,
                                  ));
                            });
                      },
                      size: Size(Responsive.width(45, context), 52),
                    ),
                    RoundShapeButton(
                      title: "Accept".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        if (double.parse(Constant.userModel!.walletAmount.toString()) >
                            double.parse(Constant.minimumAmountToAcceptRide.toString())) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialogBox(
                                  title: "Confirm Ride Request".tr,
                                  descriptions:
                                      "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride."
                                          .tr,
                                  img: Image.asset(
                                    "assets/icon/ic_green_right.png",
                                    height: 58,
                                    width: 58,
                                  ),
                                  positiveClick: () {
                                    controller.bookingModel.value.driverId = FireStoreUtils.getCurrentUid();
                                    controller.bookingModel.value.bookingStatus = BookingStatus.bookingAccepted;
                                    controller.bookingModel.value.updateAt = Timestamp.now();
                                    FireStoreUtils.setBooking(controller.bookingModel.value).then((value) async {
                                      if (value == true) {
                                        controller.getBookingDetails();

                                        ShowToastDialog.showToast("Ride accepted successfully!");

                                        UserModel? receiverUserModel =
                                            await FireStoreUtils.getUserProfile(controller.bookingModel.value.customerId.toString());
                                        Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": controller.bookingModel.value.id};

                                        await SendNotification.sendOneNotification(
                                            type: "order",
                                            token: receiverUserModel!.fcmToken.toString(),
                                            title: 'Your Ride is Accepted'.tr,
                                            customerId: receiverUserModel.id,
                                            senderId: FireStoreUtils.getCurrentUid(),
                                            bookingId: controller.bookingModel.value.id.toString(),
                                            driverId: controller.bookingModel.value.driverId.toString(),
                                            body:
                                                'Your ride #${controller.bookingModel.value.id.toString().substring(0, 4)} has been confirmed.',
                                            payload: playLoad);
                                        Navigator.pop(context);
                                      } else {
                                        ShowToastDialog.showToast("Something went wrong!");
                                        Navigator.pop(context);
                                      }
                                    });
                                    controller.getBookingDetails();
                                    Navigator.pop(context);
                                  },
                                  negativeClick: () {
                                    Navigator.pop(context);
                                  },
                                  positiveString: "Confirm".tr,
                                  negativeString: "Cancel".tr,
                                  themeChange: themeChange);
                            },
                          );
                        } else {
                          ShowToastDialog.showToast(
                              "You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
                        }
                      },
                      size: Size(Responsive.width(45, context), 52),
                    ),
                  },
                  if (controller.bookingModel.value.bookingStatus != BookingStatus.bookingCancelled &&
                      controller.bookingModel.value.bookingStatus != BookingStatus.bookingRejected &&
                      controller.bookingModel.value.bookingStatus != BookingStatus.bookingPlaced &&
                      controller.bookingModel.value.bookingStatus != BookingStatus.bookingCompleted &&
                      controller.bookingModel.value.bookingStatus != BookingStatus.bookingOngoing) ...{
                    RoundShapeButton(
                      title: "Cancel".tr,
                      buttonColor: AppThemData.grey50,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.to(() => ReasonForCancelView(
                              bookingModel: controller.bookingModel.value,
                            ));
                      },
                      size: Size(Responsive.width(45, context), 52),
                    ),
                    RoundShapeButton(
                      title: "Pickup".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.toNamed(Routes.ASK_FOR_OTP, arguments: {
                          "bookingModel": controller.bookingModel.value,
                        });
                      },
                      size: Size(Responsive.width(45, context), 52),
                    )
                  },
                  if (controller.bookingModel.value.bookingStatus == BookingStatus.bookingOngoing) ...{
                    RoundShapeButton(
                      title: "Complete Ride".tr,
                      buttonColor: AppThemData.success500,
                      buttonTextColor: AppThemData.white,
                      onTap: () {
                        controller.getBookingDetails();
                        if (controller.bookingModel.value.paymentType != Constant.paymentModel!.cash!.name) {
                          if (controller.bookingModel.value.paymentStatus == true) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    themeChange: themeChange,
                                    title: "Confirm Ride Completion".tr,
                                    descriptions: "Are you sure you want complete this ride?".tr,
                                    positiveString: "Complete".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      Navigator.pop(context);
                                      controller.completeBooking(controller.bookingModel.value);
                                      controller.getBookingDetails();
                                      Get.back();

                                      // Get.to(const HomeView());

                                      // Get.offAll(const HomeView());
                                    },
                                    negativeClick: () {
                                      Navigator.pop(context);
                                    },
                                    img: Icon(
                                      Icons.monetization_on,
                                      color: AppThemData.primary500,
                                      size: 40,
                                    ),
                                  );
                                });
                          } else {
                            ShowToastDialog.showToast("Payment of this ride is Remaining From Customer");
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  themeChange: themeChange,
                                  title: "Confirm Cash Payment".tr,
                                  descriptions: "Are you sure you want complete the ride with a cash payment?".tr,
                                  positiveString: "Complete".tr,
                                  negativeString: "Cancel".tr,
                                  positiveClick: () async {
                                    if (controller.bookingModel.value.paymentType == Constant.paymentModel!.cash!.name) {
                                      Navigator.pop(context);
                                      controller.bookingModel.value.paymentStatus = true;
                                      WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
                                          id: Constant.getUuid(),
                                          amount:
                                              "${Constant.calculateAdminCommission(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString(), adminCommission: controller.bookingModel.value.adminCommission)}",
                                          createdDate: Timestamp.now(),
                                          paymentType: "Wallet",
                                          transactionId: controller.bookingModel.value.id,
                                          isCredit: false,
                                          type: Constant.typeDriver,
                                          userId: controller.bookingModel.value.driverId,
                                          note: "Admin commission Debited",
                                          adminCommission: controller.bookingModel.value.adminCommission);

                                      await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
                                        if (value == true) {
                                          await FireStoreUtils.updateDriverUserWallet(
                                              amount:
                                                  "-${Constant.calculateAdminCommission(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString(), adminCommission: controller.bookingModel.value.adminCommission)}");
                                        }
                                      });

                                      await FireStoreUtils.setBooking(controller.bookingModel.value).then((value) async {
                                        controller.completeBooking(controller.bookingModel.value);
                                        await FireStoreUtils.updateTotalEarning(
                                            amount: (double.parse(Constant.calculateFinalAmount(controller.bookingModel.value).toString()) -
                                                    double.parse(Constant.calculateAdminCommission(
                                                            amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString(),
                                                            adminCommission: controller.bookingModel.value.adminCommission)
                                                        .toString()))
                                                .toString());
                                        controller.getBookingDetails();
                                        Navigator.pop(context);
                                        Get.to(const HomeView());

                                        // Get.back();
                                        // Get.offAll(const HomeView());
                                      });
                                    } else {
                                      if (controller.bookingModel.value.paymentStatus == true) {
                                        controller.completeBooking(controller.bookingModel.value);
                                        controller.getBookingDetails();
                                        Navigator.pop(context);
                                        Get.to(const HomeView());
                                        // Get.back();
                                        // Get.offAll(const HomeView());
                                      } else {
                                        ShowToastDialog.showToast("Payment of this ride is remaining from Customer");
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  negativeClick: () {
                                    Navigator.pop(context);
                                  },
                                  img: Icon(
                                    Icons.monetization_on,
                                    color: AppThemData.primary500,
                                    size: 40,
                                  ),
                                );
                              });
                        }
                      },
                      size: Size(Responsive.width(45, context), 52),
                    ),
                    RoundShapeButton(
                      title: "Track Ride".tr,
                      buttonColor: AppThemData.primary500,
                      buttonTextColor: AppThemData.black,
                      onTap: () {
                        Get.toNamed(Routes.TRACK_RIDE_SCREEN, arguments: {"bookingModel": controller.bookingModel.value});
                      },
                      size: Size(Responsive.width(45, context), 52),
                    )
                  },
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => controller.getBookingDetails(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ride Status'.tr,
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            BookingStatus.getBookingStatusTitle(controller.bookingModel.value.bookingStatus ?? ''),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: BookingStatus.getBookingStatusTitleColor(controller.bookingModel.value.bookingStatus ?? ''),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      TitleView(titleText: 'Cab Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller.bookingModel.value.vehicleType == null
                                    ? Constant.profileConstant
                                    : controller.bookingModel.value.vehicleType!.image,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.bookingModel.value.vehicleType == null
                                          ? ""
                                          : controller.bookingModel.value.vehicleType!.title,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      (controller.bookingModel.value.paymentStatus ?? false)
                                          ? 'Payment is Completed'.tr
                                          : 'Payment is Pending'.tr,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    Constant.amountShow(
                                        amount: Constant.calculateFinalAmount(controller.bookingModel.value).toStringAsFixed(2)),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/icon/ic_multi_person.svg"),
                                      const SizedBox(width: 6),
                                      Text(
                                        controller.bookingModel.value.vehicleType == null
                                            ? ""
                                            : controller.bookingModel.value.vehicleType!.persons,
                                        style: GoogleFonts.inter(
                                          color: AppThemData.primary500,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      FutureBuilder<UserModel?>(
                          future: FireStoreUtils.getUserProfile(controller.bookingModel.value.customerId ?? ''),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            UserModel customerModel = snapshot.data ?? UserModel();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleView(titleText: 'Customer Details'.tr, padding: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                                Container(
                                  width: Responsive.width(100, context),
                                  padding: const EdgeInsets.all(16),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        margin: const EdgeInsets.only(right: 10),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: themeChange.isDarkTheme() ? AppThemData.grey950 : AppThemData.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(200),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(customerModel.profilePic != null
                                                ? customerModel.profilePic!.isNotEmpty
                                                    ? customerModel.profilePic ?? Constant.profileConstant
                                                    : Constant.profileConstant
                                                : Constant.profileConstant),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          customerModel.fullName ?? '',
                                          style: GoogleFonts.inter(
                                            color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Get.to(() => ChatScreenView(
                                                  receiverId: controller.bookingModel.value.customerId ?? '',
                                                ));
                                          },
                                          child: SvgPicture.asset("assets/icon/ic_message.svg")),
                                      const SizedBox(width: 12),
                                      InkWell(
                                          onTap: () {
                                            Constant().launchCall("${customerModel.countryCode}${customerModel.phoneNumber}");
                                          },
                                          child: SvgPicture.asset("assets/icon/ic_phone.svg"))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            );
                          }),
                      PickDropPointView(
                        pickUpAddress: controller.bookingModel.value.pickUpLocationAddress ?? '',
                        dropAddress: controller.bookingModel.value.dropLocationAddress ?? '',
                      ),
                      TitleView(titleText: 'Ride Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_calendar.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                      themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Date'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.bookingModel.value.bookingTime == null
                                      ? ""
                                      : controller.bookingModel.value.bookingTime!.toDate().dateMonthYear(),
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 0.11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_time.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                      themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Time'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  controller.bookingModel.value.bookingTime == null
                                      ? ""
                                      : controller.bookingModel.value.bookingTime!.toDate().time(),
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 0.11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/ic_distance.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                      themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Distance'.tr,
                                    style: GoogleFonts.inter(
                                      color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                FutureBuilder<String>(
                                  future: controller.getDistanceInKm(),
                                  initialData: '',
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    return Text(
                                      snapshot.data ?? '',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 0.11,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TitleView(titleText: 'Price Details'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 12),
                        decoration: ShapeDecoration(
                          color: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PriceRowView(
                                price: controller.bookingModel.value.subTotal.toString(),
                                title: "Amount".tr,
                                priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              ),
                              const SizedBox(height: 16),
                              PriceRowView(
                                  price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                  title: "Discount".tr,
                                  priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                              const SizedBox(height: 16),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.bookingModel.value.taxList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                  return Column(
                                    children: [
                                      PriceRowView(
                                          price: Constant.amountToShow(
                                              amount: Constant.calculateTax(
                                                      amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(),
                                                      taxModel: taxModel)
                                                  .toString()),
                                          title:
                                              "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                          priceColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                          titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Divider(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                              const SizedBox(height: 12),
                              PriceRowView(
                                price:
                                    Constant.amountToShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                title: "Total Amount".tr,
                                priceColor: AppThemData.primary500,
                                titleColor: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                              ),
                            ],
                          ),
                        ),
                      ),
                      TitleView(titleText: 'Payment Method'.tr, padding: const EdgeInsets.fromLTRB(0, 20, 0, 12)),
                      Container(
                        width: Responsive.width(100, context),
                        height: 56,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (controller.bookingModel.value.paymentType == "Cash")
                                ? SvgPicture.asset("assets/icon/ic_cash.svg")
                                : (controller.bookingModel.value.paymentType == "Wallet")
                                    ? SvgPicture.asset(
                                        "assets/icon/ic_wallet.svg",
                                        height: 24,
                                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                                      )
                                    : (controller.bookingModel.value.paymentType == "Razorpay")
                                        ? Image.asset("assets/images/ig_razorpay.png", height: 24, width: 24)
                                        : (controller.bookingModel.value.paymentType == "Paypal")
                                            ? Image.asset("assets/images/ig_paypal.png", height: 24, width: 24)
                                            : (controller.bookingModel.value.paymentType == "Strip")
                                                ? Image.asset("assets/images/ig_stripe.png", height: 24, width: 24)
                                                : (controller.bookingModel.value.paymentType == "PayStack")
                                                    ? Image.asset("assets/images/ig_paystack.png", height: 24, width: 24)
                                                    : (controller.bookingModel.value.paymentType == "Mercado Pago")
                                                        ? Image.asset("assets/images/ig_marcadopago.png", height: 24, width: 24)
                                                        : (controller.bookingModel.value.paymentType == "payfast")
                                                            ? Image.asset("assets/images/ig_payfast.png", height: 24, width: 24)
                                                            : (controller.bookingModel.value.paymentType == "Flutter Wave")
                                                                ? Image.asset("assets/images/ig_flutterwave.png", height: 24, width: 24)
                                                                : SvgPicture.asset("assets/icons/ic_cash.svg"),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                controller.bookingModel.value.paymentType ?? '',
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
