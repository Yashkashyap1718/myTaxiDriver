import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? title;
  String? amount;
  String? code;
  bool? active;
  String? id;
  String? minAmount;
  Timestamp? expireAt;
  bool? isFix;
  bool? isPrivate;

  CouponModel({this.title, this.amount, this.code, this.active, this.id, this.minAmount, this.expireAt, this.isFix, this.isPrivate});

  CouponModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    amount = json['amount'] ?? '0.0';
    code = json['code'];
    active = json['active'];
    minAmount = json['minAmount'];
    id = json['id'];
    isPrivate = json['isPrivate'];
    expireAt = json['expireAt'];
    isFix = json['isFix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['amount'] = amount;
    data['code'] = code;
    data['minAmount'] = minAmount;
    data['active'] = active;
    data['id'] = id;
    data['isPrivate'] = isPrivate;
    data['expireAt'] = expireAt;
    data['isFix'] = isFix;
    return data;
  }
}
