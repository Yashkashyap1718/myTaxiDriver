import 'dart:convert';

class VehicleBrandModel {
  final String id;
  final bool isEnable;
  final String title;

  VehicleBrandModel({
    required this.id,
    required this.isEnable,
    required this.title,
  });

  factory VehicleBrandModel.fromRawJson(String str) => VehicleBrandModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) => VehicleBrandModel(
    id: json["id"],
    isEnable: json["isEnable"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isEnable": isEnable,
    "title": title,
  };
}
