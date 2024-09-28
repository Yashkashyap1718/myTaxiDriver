import 'dart:convert';

class VehicleModelModel {
  final String id;
  final String brandId;
  final bool isEnable;
  final String title;

  VehicleModelModel({
    required this.id,
    required this.brandId,
    required this.isEnable,
    required this.title,
  });

  factory VehicleModelModel.fromRawJson(String str) => VehicleModelModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleModelModel.fromJson(Map<String, dynamic> json) => VehicleModelModel(
    id: json["id"],
    brandId: json["brandId"],
    isEnable: json["isEnable"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brandId": brandId,
    "isEnable": isEnable,
    "title": title,
  };
}
