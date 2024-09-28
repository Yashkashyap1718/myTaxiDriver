class AdminCommission {
  String? value;
  bool? active;
  bool? isFix;

  AdminCommission({this.value, this.active, this.isFix});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    active = json['active'];
    isFix = json['isFix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['active'] = active;
    data['isFix'] = isFix;
    return data;
  }
}
