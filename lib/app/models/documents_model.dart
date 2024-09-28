import 'dart:convert';

class DocumentsModel {
  final String id;
  final bool isEnable;
  final bool isTwoSide;
  final String title;

  DocumentsModel({
    required this.id,
    required this.isEnable,
    required this.isTwoSide,
    required this.title,
  });

  factory DocumentsModel.fromRawJson(String str) => DocumentsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
    id: json["id"],
    isEnable: json["isEnable"],
    isTwoSide: json["isTwoSide"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isEnable": isEnable,
    "isTwoSide": isTwoSide,
    "title": title,
  };
}
