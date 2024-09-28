import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/app/models/chat_model/chat_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends StatelessWidget {
  final String receiverId;

  const ChatScreenView({
    super.key,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: ChatScreenController(),
        builder: (controller) {
          controller.getData(receiverId);
          return Obx(
            () => Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
              appBar: AppBar(
                forceMaterialTransparency: true,
                surfaceTintColor: Colors.transparent,
                backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
                titleSpacing: 0,
                automaticallyImplyLeading: true,
                shape: Border(bottom: BorderSide(color: themeChange.isDarkTheme() ? AppThemData.grey800 : AppThemData.grey100, width: 1)),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    controller.isLoading.value
                        ? Constant.loader()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                                height: 36,
                                width: 36,
                                fit: BoxFit.cover,
                                imageUrl: controller.receiverUserModel.value.profilePic == null || controller.receiverUserModel.value.profilePic == ""
                                    ? Constant.profileConstant
                                    : controller.receiverUserModel.value.profilePic.toString()),
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(controller.receiverUserModel.value.fullName ?? '',
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 0.08,
                        )),
                  ],
                ),
                actions: [
                  InkWell(
                      onTap: () {
                        Constant().launchCall("${controller.receiverUserModel.value.countryCode}${controller.receiverUserModel.value.phoneNumber}");
                      },
                      child: SvgPicture.asset("assets/icon/ic_phone.svg")),
                  const SizedBox(width: 12),
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Column(
                      children: [
                        Expanded(
                          child: PaginateFirestore(
                            scrollDirection: Axis.vertical,
                            query: FireStoreUtils.fireStore
                                .collection(CollectionName.chat)
                                .doc(controller.senderUserModel.value.id)
                                .collection(controller.receiverUserModel.value.id.toString())
                                .orderBy("timestamp", descending: true),
                            itemBuilderType: PaginateBuilderType.listView,
                            isLive: true,
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            reverse: true,
                            onEmpty: Constant.showEmptyView(message: "No conversion found".tr),
                            onError: (error) {
                              return ErrorWidget(error);
                            },
                            itemBuilder: (context, documentSnapshots, index) {
                              ChatModel chatModel = ChatModel.fromJson(documentSnapshots[index].data() as Map<String, dynamic>);
                              return Container(
                                  padding: const EdgeInsets.only(left: 14, right: 14, top: 06, bottom: 06),
                                  child: chatBubbles(chatModel.senderId == controller.senderUserModel.value.id ? true : false, chatModel, themeChange));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.messageTextEditorController.value,
                            textAlign: TextAlign.start,
                            maxLines: null,
                            minLines: 1,
                            textInputAction: TextInputAction.done,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.red),
                                isDense: true,
                                fillColor: themeChange.isDarkTheme() ? AppThemData.grey900 : AppThemData.grey50,
                                filled: true,
                                enabled: true,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (controller.messageTextEditorController.value.text.isNotEmpty) {
                                      controller.sendMessage();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(2, 2, 16, 2),
                                    child: SvgPicture.asset(
                                      "assets/icon/ic_send.svg",
                                      height: 15,
                                      width: 15,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                disabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide(color: Colors.transparent)),
                                focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide(color: Colors.transparent)),
                                enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide(color: Colors.transparent)),
                                errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide(color: Colors.transparent)),
                                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(100)), borderSide: BorderSide(color: Colors.transparent)),
                                hintText: "Type your message here...".tr,
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: themeChange.isDarkTheme() ? AppThemData.grey400 : AppThemData.grey500,
                                )),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  chatBubbles(bool isMe, ChatModel chatModel, themeChange) {
    return Row(
      mainAxisAlignment: isMe == false ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: isMe
                    ? AppThemData.primary500
                    : themeChange.isDarkTheme()
                        ? AppThemData.grey900
                        : AppThemData.grey50,
                borderRadius: isMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      )),
            child: Column(
              crossAxisAlignment: isMe == false ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${chatModel.message}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(Constant.timestampToTime(chatModel.timestamp!),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.black,
                    ))
              ],
            ),
          ).paddingOnly(left: isMe == false ? 0 : 70, right: isMe == false ? 70 : 0),
        ),
      ],
    );
  }
}
