import 'dart:convert';

class NewPaymentMethodModel {
  final String title;
  final String imagePath;
  final String value;

  NewPaymentMethodModel({
    required this.title,
    required this.imagePath,
    required this.value,
  });

  factory NewPaymentMethodModel.fromRawJson(String str) => NewPaymentMethodModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewPaymentMethodModel.fromJson(Map<String, dynamic> json) => NewPaymentMethodModel(
    title: json["title"],
    imagePath: json["imagePath"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "imagePath": imagePath,
    "value": value,
  };
}
