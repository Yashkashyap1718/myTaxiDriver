// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/chat_model/chat_model.dart';
import 'package:driver/app/models/chat_model/inbox_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController {
  Rx<UserModel> receiverUserModel = UserModel().obs;
  Rx<DriverUserModel> senderUserModel = DriverUserModel().obs;
  final messageTextEditorController = TextEditingController().obs;
  RxString message = "".obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getData(String receiverId) async {
    await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      senderUserModel.value = value ?? DriverUserModel();
    });
    await FireStoreUtils.getUserProfile(receiverId).then((value) {
      receiverUserModel.value = value ?? UserModel();
    });
    isLoading.value = false;
  }

  sendMessage() async {
    InboxModel inboxModel = InboxModel(
        archive: false,
        lastMessage: messageTextEditorController.value.text.trim(),
        mediaUrl: "",
        receiverId: receiverUserModel.value.id.toString(),
        seen: false,
        senderId: senderUserModel.value.id.toString(),
        timestamp: Timestamp.now(),
        type: "text");

    await FireStoreUtils.fireStore
        .collection(CollectionName.chat)
        .doc(senderUserModel.value.id.toString())
        .collection("inbox")
        .doc(receiverUserModel.value.id.toString())
        .set(inboxModel.toJson());

    await FireStoreUtils.fireStore
        .collection(CollectionName.chat)
        .doc(receiverUserModel.value.id.toString())
        .collection("inbox")
        .doc(senderUserModel.value.id.toString())
        .set(inboxModel.toJson());

    ChatModel chatModel = ChatModel(
        type: "text",
        timestamp: Timestamp.now(),
        senderId: senderUserModel.value.id.toString(),
        seen: false,
        receiverId: receiverUserModel.value.id.toString(),
        mediaUrl: "",
        chatID: Constant.getUuid(),
        message: messageTextEditorController.value.text.trim());

    message.value = messageTextEditorController.value.text;
    messageTextEditorController.value.clear();

    await FireStoreUtils.fireStore
        .collection(CollectionName.chat)
        .doc(senderUserModel.value.id.toString())
        .collection(receiverUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());
    await FireStoreUtils.fireStore
        .collection(CollectionName.chat)
        .doc(receiverUserModel.value.id.toString())
        .collection(senderUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());

    Map<String, dynamic> playLoad = <String, dynamic>{
      "type": "chat",
      "senderId": senderUserModel.value.id.toString(),
      "receiverId": receiverUserModel.value.id.toString(),
    };

    await SendNotification.sendOneNotification(
        type: "chat", token: receiverUserModel.value.fcmToken.toString(), title: senderUserModel.value.fullName.toString(), body: message.value, payload: playLoad);

    message.value = "";
  }
}
