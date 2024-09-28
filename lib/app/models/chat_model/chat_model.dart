import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? chatID;
  String? type;
  String? senderId;
  String? receiverId;
  String? message;
  String? mediaUrl;
  bool? seen;
  Timestamp? timestamp;

  ChatModel({this.chatID, this.type, this.senderId, this.receiverId, this.message, this.mediaUrl, this.seen, this.timestamp});

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatID = json['chatID'];
    type = json['type'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    mediaUrl = json['mediaUrl'];
    seen = json['seen'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatID'] = chatID;
    data['type'] = type;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['message'] = message;
    data['mediaUrl'] = mediaUrl;
    data['seen'] = seen;
    data['timestamp'] = timestamp;
    return data;
  }
}
