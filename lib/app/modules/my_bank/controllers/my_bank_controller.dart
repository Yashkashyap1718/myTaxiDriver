import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/bank_detail_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class MyBankController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  TextEditingController bankHolderNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchCityController = TextEditingController();
  TextEditingController bankBranchCountryController = TextEditingController();
  RxString editingId = "".obs;
  RxBool isLoading = false.obs;

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
  List<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isLoading.value = true;
    bankDetailsList.clear();
    await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        bankDetailsList.addAll(value);
      }
    });
    isLoading.value = false;
  }

  setDefault() {
    bankHolderNameController.text = "";
    bankAccountNumberController.text = "";
    swiftCodeController.text = "";
    ifscCodeController.text = "";
    bankNameController.text = "";
    bankBranchCityController.text = "";
    bankBranchCountryController.text = "";
    editingId.value = "";
  }

  setBankDetails() async {
    bankDetailsModel.value.id = Constant.getUuid();
    bankDetailsModel.value.driverID = FireStoreUtils.getCurrentUid();
    bankDetailsModel.value.holderName = bankHolderNameController.value.text;
    bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
    bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
    bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
    bankDetailsModel.value.bankName = bankNameController.value.text;
    bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
    bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;
    await FireStoreUtils.addBankDetail(bankDetailsModel.value);
    setDefault();
  }

  updateBankDetail() async {
    bankDetailsModel.value.id = editingId.value;
    bankDetailsModel.value.driverID = FireStoreUtils.getCurrentUid();
    bankDetailsModel.value.holderName = bankHolderNameController.value.text;
    bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
    bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
    bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
    bankDetailsModel.value.bankName = bankNameController.value.text;
    bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
    bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;
    await FireStoreUtils.updateBankDetail(bankDetailsModel.value);
    setDefault();
  }

  deleteBankDetails(BankDetailsModel bankDetailsModel) async {
    isLoading = true.obs;
    ShowToastDialog.showLoader("Please Wait");
    await FirebaseFirestore.instance.collection(CollectionName.bankDetails).doc(bankDetailsModel.id).delete().then((value) {
      ShowToastDialog.showToast("Bank Detail deleted...!");
    }).catchError((error) {
      ShowToastDialog.showToast("Something went wrong");
    });
    getData();
    ShowToastDialog.closeLoader();
    isLoading = false.obs;
  }
}
