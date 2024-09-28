class TaxModel {
  String? country;
  bool? active;
  String? value;
  String? id;
  bool? isFix;
  String? name;

  TaxModel({this.country, this.active, this.value, this.id, this.isFix, this.name});

  @override
  String toString() {
    return 'TaxModel{country: $country, active: $active, value: $value, id: $id, isFix: $isFix, name: $name}';
  }

  TaxModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    active = json['active'];
    value = json['value'];
    id = json['id'];
    isFix = json['isFix'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['active'] = active;
    data['value'] = value;
    data['id'] = id;
    data['isFix'] = isFix;
    data['name'] = name;
    return data;
  }
}

class TaxData {
  int? id;
  int? providerId;
  String? title;
  String? type;
  num? value;
  num? totalCalculatedValue;

  TaxData({this.id, this.providerId, this.title, this.type, this.value, this.totalCalculatedValue});

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      providerId: json['provider_id'],
      title: json['title'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['title'] = title;
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}
