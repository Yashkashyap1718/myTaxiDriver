import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyDriverModel {
  Timestamp? createAt;
  String? driverEmail;
  String? driverId;
  String? driverName;
  List<VerifyDocument>? verifyDocument;

  VerifyDriverModel({
    this.createAt,
    this.driverEmail,
    this.driverId,
    this.driverName,
    this.verifyDocument,
  });

  factory VerifyDriverModel.fromRawJson(String str) => VerifyDriverModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyDriverModel.fromJson(Map<String, dynamic> json) => VerifyDriverModel(
        createAt: json["createAt"],
        driverEmail: json["driverEmail"],
        driverId: json["driverId"],
        driverName: json["driverName"],
        verifyDocument: List<VerifyDocument>.from(json["verifyDocument"].map((x) => VerifyDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "driverEmail": driverEmail,
        "driverId": driverId,
        "driverName": driverName,
        "verifyDocument": verifyDocument == null ? [] : List<dynamic>.from(verifyDocument!.map((x) => x.toJson())),
      };
}

class VerifyDocument {
  String? documentId;
  String? name;
  String? number;
  String? dob;
  List<dynamic> documentImage;
  bool? isVerify;

  VerifyDocument({
    this.documentId,
    this.name,
    this.number,
    this.dob,
    required this.documentImage,
    this.isVerify,
  });

  factory VerifyDocument.fromRawJson(String str) => VerifyDocument.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyDocument.fromJson(Map<String, dynamic> json) => VerifyDocument(
        documentId: json["documentId"],
        name: json["name"],
        number: json["number"],
        dob: json["dob"],
        documentImage: json["documentImage"] ?? [],
        isVerify: json["isVerify"],
      );

  Map<String, dynamic> toJson() => {
        "documentId": documentId,
        "name": name,
        "number": number,
        "dob": dob,
        "documentImage": documentImage ?? [],
        "isVerify": isVerify,
      };
}
