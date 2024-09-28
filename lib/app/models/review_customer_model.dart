import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String? rating;
  Timestamp? date;
  String? customerId;
  String? comment;
  String? driverId;

  ReviewModel({this.id, this.date, this.rating, this.customerId, this.comment, this.driverId});

  @override
  String toString() {
    return 'ReviewModel{id: $id, rating: $rating, date: $date, customerId: $customerId, comment: $comment, driverId: $driverId}';
  }

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    rating = json['rating'];
    customerId = json['customerId'];
    comment = json['comment'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['driverId'] = driverId;
    return data;
  }
}
