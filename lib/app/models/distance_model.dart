import 'dart:convert';

class DistanceModel {
  String? distance;
  String? distanceType;

  DistanceModel({
    this.distance,
    this.distanceType,
  });

  factory DistanceModel.fromRawJson(String str) => DistanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DistanceModel.fromJson(Map<String, dynamic> json) => DistanceModel(
    distance: json["distance"],
    distanceType: json["distanceType"],
  );

  Map<String, dynamic> toJson() => {
    "distance": distance,
    "distanceType": distanceType,
  };
}
