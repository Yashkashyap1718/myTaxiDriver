class LanguageModel {
  String? id;
  String? name;
  String? code;
  bool? active;

  LanguageModel({this.id, this.name, this.code, this.active});

  @override
  String toString() {
    return 'LanguageModel{id: $id, name: $name, code: $code, active: $active}';
  }

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    data['code'] = code;
    return data;
  }
}
