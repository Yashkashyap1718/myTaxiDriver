import 'package:cloud_firestore/cloud_firestore.dart';

class SupportTicketModel {
  String? id;
  String? title;
  String? subject;
  String? description;
  String? status;
  String? type;
  String? userId;
  String? notes;
  Timestamp? createAt;
  Timestamp? updateAt;
  List<dynamic>? attachments;

  @override
  String toString() {
    return 'SupportTicketModel{id: $id, title: $title, subject: $subject, description: $description, status: $status, attachments: $attachments, userID: $userId, notes: $notes, type: $type, createAt: $createAt, updateAt: $updateAt}';
  }

  SupportTicketModel(
      {this.id,
      this.title,
      this.subject,
      this.description,
      this.type,
      this.status,
      this.userId,
      this.notes,
      this.createAt,
      this.updateAt,
      this.attachments});

  SupportTicketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    subject = json['subject'] ?? "";
    description = json['description'] ?? "";
    type = json['type'] ?? "";
    status = json['status'] ?? "";
    notes = json['notes'] ?? "";
    userId = json['userId'] ?? "";
    createAt = json['createAt'] ?? "";
    updateAt = json['updateAt'] ?? "";
    attachments = json['attachments'].cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subject'] = subject;
    data['description'] = description;
    data['type'] = type;
    data['status'] = status;
    data['notes'] = notes;
    data['userId'] = userId;
    data['createAt'] = createAt;
    data['updateAt'] = updateAt;
    data['attachments'] = attachments;
    return data;
  }
}
