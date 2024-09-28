// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:driver/app/models/documents_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/utils/fire_store_utils.dart';

class VerifyDocumentsController extends GetxController {
  RxList<DocumentsModel> documentList = <DocumentsModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxBool isVerified = false.obs;

  @override
  void onInit() {
    getData();
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

  getData() async {
    documentList.clear();
    verifyDriverModel.value = await FireStoreUtils.getVerifyDriver(FireStoreUtils.getCurrentUid()) ?? VerifyDriverModel();
    documentList.value = await FireStoreUtils.getDocumentList() ?? [];
    userModel.value = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid())??DriverUserModel();
  }

  bool checkUploadedData(String documentId) {
    List<VerifyDocument> doc = verifyDriverModel.value.verifyDocument ?? [];
    int index = doc.indexWhere((element) => element.documentId == documentId);

    return index != -1;
  }
  bool checkVerifiedData(String documentId) {
    List<VerifyDocument> doc = verifyDriverModel.value.verifyDocument ?? [];
    int index = doc.indexWhere((element) => element.documentId == documentId);
    if(index!=-1){
      return doc[index].isVerify??false;
    }else{
      return false;
    }
  }
}
