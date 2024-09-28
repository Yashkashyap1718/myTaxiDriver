import 'package:cloud_firestore/cloud_firestore.dart';

class Positions {
  String? geohash;
  GeoPoint? geoPoint;

  Positions({this.geohash, this.geoPoint});

  Positions.fromJson(Map<String, dynamic> json) {
    geohash = json['geohash'];
    geoPoint = json['geopoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geohash'] = geohash;
    data['geopoint'] = geoPoint;
    return data;
  }
}
