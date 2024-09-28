import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? type;
  String? title;
  String? description;
  String? bookingId;
  String? driverId;
  String? customerId;
  Timestamp? createdAt;
  String? senderId;

  NotificationModel({
    this.id,
    this.title,
    this.description,
    this.bookingId,
    this.driverId,
    this.customerId,
    this.createdAt,
    this.senderId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    driverId = json['driverId'];
    description = json['description'];
    bookingId = json['bookingId'];
    customerId = json['customerId'];
    createdAt = json['createdAt'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['driverId'] = driverId ?? "";
    data['description'] = description;
    data['customerId'] = customerId ?? "";
    data['bookingId'] = bookingId;
    data['createdAt'] = createdAt;
    data['senderId'] = senderId;
    return data;
  }

  Map<String, dynamic> toNotificationJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['driverId'] = driverId ?? "";
    data['description'] = description;
    data['customerId'] = customerId ?? "";
    data['bookingId'] = bookingId;
    data['senderId'] = senderId;
    return data;
  }
}
