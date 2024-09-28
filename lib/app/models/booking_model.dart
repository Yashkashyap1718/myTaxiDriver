import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/coupon_model.dart';
import 'package:driver/app/models/distance_model.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/positions.dart';
import 'package:driver/app/models/vehicle_type_model.dart';

import 'tax_model.dart';

class BookingModel {
  String? id;
  Timestamp? createAt;
  Timestamp? updateAt;
  String? driverId;
  LocationLatLng? pickUpLocation;
  LocationLatLng? dropLocation;
  String? pickUpLocationAddress;
  String? dropLocationAddress;
  String? bookingStatus;
  String? customerId;
  String? paymentType;
  bool? paymentStatus;
  String? cancelledBy;
  String? cancelledReason;
  String? discount;
  String? subTotal;
  String? taxTotal;
  Timestamp? bookingTime;
  Timestamp? pickupTime;
  Timestamp? dropTime;
  VehicleTypeModel? vehicleType;
  List<dynamic>? rejectedDriverId;
  String? otp;
  Positions? position;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  AdminCommission? adminCommission;
  DistanceModel? distance;

  BookingModel({
    this.createAt,
    this.updateAt,
    this.driverId,
    this.bookingStatus,
    this.id,
    this.dropLocation,
    this.pickUpLocation,
    this.dropLocationAddress,
    this.pickUpLocationAddress,
    this.customerId,
    this.paymentType,
    this.paymentStatus,
    this.cancelledBy,
    this.cancelledReason,
    this.discount,
    this.subTotal,
    this.taxTotal,
    this.bookingTime,
    this.pickupTime,
    this.dropTime,
    this.vehicleType,
    this.rejectedDriverId,
    this.otp,
    this.position,
    this.adminCommission,
    this.coupon,
    this.taxList,
    this.distance,
  });

  factory BookingModel.fromRawJson(String str) => BookingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        driverId: json["driverId"],
        bookingStatus: json["bookingStatus"],
        dropLocation: json['dropLocation'] != null ? LocationLatLng.fromJson(json['dropLocation']) : null,
        pickUpLocation: json['pickUpLocation'] != null ? LocationLatLng.fromJson(json['pickUpLocation']) : null,
        dropLocationAddress: json['dropLocationAddress'],
        pickUpLocationAddress: json['pickUpLocationAddress'],
        id: json["id"],
        customerId: json["customerId"],
        paymentType: json["paymentType"],
        paymentStatus: json["paymentStatus"],
        cancelledBy: json["cancelledBy"],
        cancelledReason: json["cancelledReason"],
        discount: json["discount"],
        subTotal: json["subTotal"],
        taxTotal: json["taxTotal"],
        bookingTime: json["bookingTime"],
        pickupTime: json["pickupTime"],
        dropTime: json["dropTime"],
        otp: json["otp"],
        vehicleType: json["vehicleType"] == null ? null : VehicleTypeModel.fromJson(json["vehicleType"]),
        rejectedDriverId: json["rejectedDriverId"] == null ? [] : List<dynamic>.from(json["rejectedDriverId"]!.map((x) => x)),
        taxList: json["taxList"] == null ? [] : List<TaxModel>.from(json["taxList"]!.map((x) => TaxModel.fromJson(x))),
        position: json["position"] == null ? null : Positions.fromJson(json["position"]),
        coupon: json["coupon"] == null ? null : CouponModel.fromJson(json["coupon"]),
        adminCommission: json["adminCommission"] == null ? null : AdminCommission.fromJson(json["adminCommission"]),
        distance: json["distance"] == null ? null : DistanceModel.fromJson(json["distance"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createAt": createAt,
        "updateAt": updateAt,
        "driverId": driverId,
        "bookingStatus": bookingStatus,
        "dropLocation": dropLocation?.toJson(),
        "pickUpLocation": pickUpLocation?.toJson(),
        "dropLocationAddress": dropLocationAddress,
        "pickUpLocationAddress": pickUpLocationAddress,
        "customerId": customerId,
        "paymentType": paymentType,
        "paymentStatus": paymentStatus,
        "cancelledBy": cancelledBy,
        "cancelledReason": cancelledReason,
        "discount": discount,
        "subTotal": subTotal,
        "taxTotal": taxTotal,
        "bookingTime": bookingTime,
        "pickupTime": pickupTime,
        "dropTime": dropTime,
        "vehicleType": vehicleType?.toJson(),
        "rejectedDriverId": rejectedDriverId == null ? [] : List<dynamic>.from(rejectedDriverId!.map((x) => x)),
        "taxList": taxList == null ? [] : (taxList!.map((x) => x.toJson()).toList()),
        "position": position?.toJson(),
        "coupon": coupon?.toJson(),
        "adminCommission": adminCommission?.toJson(),
        "distance": distance?.toJson(),
        "otp": otp,
      };
}
