import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/support_reason_model.dart';
import 'package:driver/app/models/support_ticket_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateSupportTicketController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxList<SupportReasonModel> supportReasonList = <SupportReasonModel>[].obs;
  Rx<SupportReasonModel> selectedSupportTitle = SupportReasonModel().obs;

  Rx<TextEditingController> subjectController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getSupportReason().then((value) {
      supportReasonList.value = value;
    });
  }

  Rx<SupportTicketModel> supportTicketModel = SupportTicketModel().obs;

  saveSupportTicket() async {
    if (formKey.value.currentState!.validate()) {
      ShowToastDialog.showLoader("Please Wait".tr);
      if (supportImages.isNotEmpty &&
          Constant.hasValidUrl(supportImages[0]) == false) {
        // supportImages.value = await Constant.uploadSupportImage(supportImages);
      }
    }

    supportTicketModel.value.id = Constant.getRandomString(16);
    supportTicketModel.value.title = selectedSupportTitle.value.reason;
    supportTicketModel.value.subject = subjectController.value.text;
    supportTicketModel.value.description = descriptionController.value.text;
    supportTicketModel.value.userId = FirebaseAuth.instance.currentUser!.uid;
    supportTicketModel.value.attachments = supportImages;
    supportTicketModel.value.status = "pending";
    supportTicketModel.value.createAt = Timestamp.now();
    supportTicketModel.value.updateAt = Timestamp.now();
    supportTicketModel.value.type = "driver";

    await FireStoreUtils.addSupportTicket(supportTicketModel.value)
        .then((value) {
      Get.back(result: true);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Support Ticket Saved".tr);
    }).catchError((error) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Something Went Wrong!".tr);
    });
  }

  RxList<String> supportImages = <String>[].obs;
  final ImagePicker imagePicker = ImagePicker();

  Future pickMultipleImages({String? source}) async {
    try {
      if (source == "Camera") {
        XFile? image = await imagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
        if (image == null) return;
        Get.back();

        // Compress the image using flutter_image_compress
        Uint8List? compressedBytes =
            await FlutterImageCompress.compressWithFile(
          image.path,
          quality: 50,
        );
        // Save the compressed image to a new file
        File compressedFile = File(image.path);
        await compressedFile.writeAsBytes(compressedBytes!);
        Get.back();

        supportImages.add(compressedFile.path);
      } else {
        List<XFile>? images = await imagePicker.pickMultiImage();
        if (images.isEmpty) return;
        // Get.back();

        // serviceImages.clear();
        for (var image in images) {
          Uint8List? compressedBytes =
              await FlutterImageCompress.compressWithFile(
            image.path,
            quality: 50,
          );
          File compressedFile = File(image.path);
          await compressedFile.writeAsBytes(compressedBytes!);
          supportImages.add(compressedFile.path);
        }
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
