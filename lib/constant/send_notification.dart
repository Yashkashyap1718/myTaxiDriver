// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:googleapis_auth/auth_io.dart'; // For OAuth 2.0
import 'package:http/http.dart' as http;

class SendNotification {
  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future getCharacters() {
    return http.get(Uri.parse(Constant.jsonFileURL.toString()));
  }

  static Future<String> getAccessToken() async {
    Map<String, dynamic> jsonData = {};

    await getCharacters().then((response) {
      jsonData = json.decode(response.body);
    });
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonData);

    final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
    return client.credentials.accessToken.data;
  }

  static sendOneNotification({
    required String token,
    required String title,
    required String body,
    required String type,
    required Map<String, dynamic> payload,
    String? bookingId,
    String? driverId,
    String? customerId,
    String? senderId,
  }) async {
    NotificationModel notificationModel = NotificationModel();
    if (bookingId != null) {
      notificationModel.id = Constant.getUuid();
      notificationModel.type = type;
      notificationModel.title = title;
      notificationModel.description = body;
      notificationModel.bookingId = bookingId;
      notificationModel.customerId = customerId;
      notificationModel.driverId = driverId;
      notificationModel.senderId = senderId;
      notificationModel.createdAt = Timestamp.now();
      await FireStoreUtils.setNotification(notificationModel).then((value) {});
    }

    final String accessToken = await getAccessToken();

    log("_____________________________________________________________________");
    log("token--->$token");
    log("AccessToken--->$accessToken");
    log("_____________________________________________________________________");
    print(payload);

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/${Constant.senderId}/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'message': {
            'token': token,
            'notification': {'body': body, 'title': title},
            'data': bookingId != null ? notificationModel.toNotificationJson() : payload,
          }
        },
      ),
    );
    log("====================>");
    log(response.body);
  }
}
