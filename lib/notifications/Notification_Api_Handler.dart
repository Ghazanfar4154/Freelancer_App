import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../animation.dart';
import 'Notification_Model.dart';

class NotificationApiHandler {

  static const notificationBaseUrl = "${baseUrl}notifications/notifications";

  static Future<List<NotificationModel>> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse(notificationBaseUrl);

    try {
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          List<dynamic> notificationsJson = responseData['notifications'];
          return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
        } else {
          print('Failed to fetch notifications');
          return [];
        }
      } else {
        print("Failed to fetch notifications: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> createNotification(String title, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);

    var url = Uri.parse(notificationBaseUrl);
    var data = jsonEncode({'title': title, 'description': description});

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: data,
      );

      if (res.statusCode == 201) {
        var responseData = jsonDecode(res.body);
        return responseData['status'] == true;
      } else {
        print("Failed to create notification: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
