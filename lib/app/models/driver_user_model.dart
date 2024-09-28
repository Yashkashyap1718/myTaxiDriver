import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/positions_model.dart';

class DriverUserModel {
  String? fullName;
  String? slug;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? totalEarning;
  String? gender;
  bool? isActive;
  bool? isVerified;
  bool? isOnline;
  Timestamp? createdAt;
  DriverVehicleDetails? driverVehicleDetails;
  LocationLatLng? location;
  Positions? position;
  dynamic rotation;
  String? reviewsCount;
  String? reviewsSum;

  DriverUserModel({
    this.fullName,
    this.slug,
    this.driverVehicleDetails,
    this.location,
    this.position,
    this.id,
    this.isActive,
    this.isVerified,
    this.isOnline,
    this.dateOfBirth,
    this.email,
    this.loginType,
    this.profilePic,
    this.fcmToken,
    this.countryCode,
    this.phoneNumber,
    this.walletAmount,
    this.totalEarning,
    this.createdAt,
    this.rotation,
    this.gender,
    this.reviewsCount,
    this.reviewsSum,
  });

  DriverUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    slug = json['slug'];
    id = json['id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0";
    totalEarning = json['totalEarning'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'] ?? false;
    isOnline = json['isOnline'] ?? false;
    driverVehicleDetails = json['driverVehicleDetails'] != null ? DriverVehicleDetails.fromJson(json["driverVehicleDetails"]) : null;
    isVerified = json['isVerified'] ?? false;
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : LocationLatLng();
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
    rotation = json['rotation'];
    reviewsCount = json['reviewsCount'];
    reviewsSum = json['reviewsSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['slug'] = slug;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount ?? '0.0';
    data['totalEarning'] = totalEarning ?? '0.0';
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive ?? false;
    data['isOnline'] = isOnline ?? false;
    data['isVerified'] = isVerified ?? false;
    if (driverVehicleDetails != null) {
      data["driverVehicleDetails"] = driverVehicleDetails!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['rotation'] = rotation;
    data['reviewsCount'] = reviewsCount ?? '0';
    data['reviewsSum'] = reviewsSum ?? "0.0";
    return data;
  }
}

class DriverVehicleDetails {
  String? vehicleTypeName;
  String? vehicleTypeId;
  String? brandName;
  String? brandId;
  String? modelName;
  String? modelId;
  String? vehicleNumber;
  bool? isVerified;

  DriverVehicleDetails({
    this.vehicleTypeName,
    this.vehicleTypeId,
    this.brandName,
    this.brandId,
    this.modelName,
    this.modelId,
    this.vehicleNumber,
    this.isVerified,
  });

  factory DriverVehicleDetails.fromRawJson(String str) => DriverVehicleDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DriverVehicleDetails.fromJson(Map<String, dynamic> json) => DriverVehicleDetails(
        vehicleTypeName: json["vehicleTypeName"],
        vehicleTypeId: json["vehicleTypeId"],
        brandName: json["brandName"],
        brandId: json["brandId"],
        modelName: json["modelName"],
        modelId: json["modelId"],
        vehicleNumber: json["vehicleNumber"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleTypeName": vehicleTypeName ?? '',
        "vehicleTypeId": vehicleTypeId ?? '',
        "brandName": brandName ?? '',
        "brandId": brandId ?? '',
        "modelName": modelName ?? '',
        "modelId": modelId ?? '',
        "vehicleNumber": vehicleNumber ?? '',
        "isVerified": isVerified ?? false,
      };
}
