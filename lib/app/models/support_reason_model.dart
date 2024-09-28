class SupportReasonModel {
  String? id;
  String? reason;
  String? type;

  SupportReasonModel({this.id, this.reason, this.type});

  SupportReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['type'] = type;
    return data;
  }
}
