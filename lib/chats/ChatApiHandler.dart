import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../animation.dart';

class ChatApiHandler {
  static const chatBaseUrl = "${baseUrl}chat/";
  static Future<String?> openOrCreateChat(String clientId) async {
    print("Client ID:"+clientId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("User ID"+token!);

    var url = Uri.parse("${chatBaseUrl}open-chat");
    var data = jsonEncode({'clientId': clientId});

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!, // Include 'Bearer' prefix if needed
        },
        body: data,
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          return responseData['chatId'];
        } else {
          print('Failed to open or create chat');
          return null;
        }
      } else {
        print("Failed to open or create chat: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<dynamic>> getChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("${chatBaseUrl}chats");

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
          return responseData['chats'];
        } else {
          print('Failed to fetch chats');
          return [];
        }
      } else {
        print("Failed to fetch chats: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<dynamic>> getMessages(String chatId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("${chatBaseUrl}chats/$chatId/messages");

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
          return responseData['messages'];
        } else {
          print('Failed to fetch messages');
          return [];
        }
      } else {
        print("Failed to fetch messages: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> sendMessage(String chatId, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("${chatBaseUrl}send-message");
    var data = jsonEncode({'chatId': chatId, 'message': message});

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: data,
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        return responseData['status'] == true;
      } else {
        print("Failed to send message: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
