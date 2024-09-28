import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/app_bar_with_border.dart';
import 'package:driver/constant_widgets/star_rating.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewScreenView extends GetView<HomeController> {
  const ReviewScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          appBar: AppBarWithBorder(
            title: "Customer Reviews".tr,
            bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.reviewList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: ShapeDecoration(
                          color: themeChange.isDarkTheme() ? controller.colorDark[index % 4] : controller.color[index % 4],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FutureBuilder<UserModel?>(
                                  future: FireStoreUtils.getUserProfile(controller.reviewList[index].customerId.toString()),
                                  builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const SizedBox();
                                      default:
                                        if (snapshot.hasError) {
                                          return Container(
                                            width: 40,
                                            height: 40,
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
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              imageUrl: userModel!.profilePic.toString(),
                                              errorWidget: (context, url, error) {
                                                return Container(
                                                  width: 40,
                                                  height: 40,
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
                                Column(
                                  children: [
                                    FutureBuilder<UserModel?>(
                                      future: FireStoreUtils.getUserProfile(controller.reviewList[index].customerId.toString()),
                                      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
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
                                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
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
                                      rating: double.parse(controller.reviewList[index].rating.toString()),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              controller.reviewList[index].comment.toString(),
                              style: GoogleFonts.inter(
                                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
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
        );
      },
    );
  }
}
