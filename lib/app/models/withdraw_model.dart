import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/bank_detail_model.dart';

class WithdrawModel {
  String? id;
  String? driverId;
  String? note;
  String? paymentStatus;
  String? adminNote;
  String? amount;
  Timestamp? createdDate;
  Timestamp? paymentDate;
  BankDetailsModel? bankDetails;

  WithdrawModel({
    this.id,
    this.driverId,
    this.note,
    this.paymentStatus,
    this.adminNote,
    this.amount,
    this.createdDate,
    this.paymentDate,
    this.bankDetails,
  });

  @override
  String toString() {
    return 'WithdrawModel{id: $id, driverId: $driverId, note: $note, paymentStatus: $paymentStatus, adminNote: $adminNote, amount: $amount, createdDate: $createdDate, paymentDate: $paymentDate, bankDetails: $bankDetails}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['note'] = note;
    data['paymentStatus'] = paymentStatus;
    data['adminNote'] = adminNote;
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['paymentDate'] = paymentDate;

    if (bankDetails != null) {
      data['bank_details'] = bankDetails!.toJson();
    }
    return data;
  }

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    note = json['note'];
    paymentStatus = json['paymentStatus'];
    adminNote = json['adminNote'];
    amount = json['amount'];
    createdDate = json['createdDate'];
    paymentDate = json['paymentDate'];
    bankDetails = json['bank_details'] != null ? BankDetailsModel.fromJson(json['bank_details']) : null;
  }
}
