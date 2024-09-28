import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_commission.dart';

class WalletTransactionModel {
  String? amount;
  Timestamp? createdDate;
  String? id;
  String? userId;
  String? transactionId;
  String? paymentType;
  String? note;
  String? type;
  bool? isCredit;
  AdminCommission? adminCommission;

  WalletTransactionModel({this.amount, this.createdDate, this.id, this.userId, this.transactionId, this.paymentType, this.note, this.type, this.isCredit, this.adminCommission});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdDate = json['createdDate'];
    id = json['id'];
    userId = json['userId'];
    transactionId = json['transactionId'];
    paymentType = json['paymentType'];
    note = json['note'];
    isCredit = json['isCredit'];
    type = json['type'];
    adminCommission = json["adminCommission"] == null ? null : AdminCommission.fromJson(json["adminCommission"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['id'] = id;
    data['userId'] = userId;
    data['transactionId'] = transactionId;
    data['paymentType'] = paymentType;
    data['note'] = note;
    data['isCredit'] = isCredit;
    data['type'] = type;
    data['adminCommission'] = adminCommission?.toJson();
    return data;
  }
}
