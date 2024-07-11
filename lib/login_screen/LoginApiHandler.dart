import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Home%20Screen/MainPage.dart';
import 'package:untitled/googlsignin/GoogleSignIn.dart';
import 'package:untitled/linkedinsignin/linkedinsignin.dart';
import 'package:untitled/login_screen/RegisterNewUser.dart';
import 'package:untitled/login_screen/new_password.dart';

import '../animation.dart';

class LoginApiHandler {

  static loginUser(Map pdata, BuildContext context) async {
    var url = Uri.parse("${baseUrl}login");

    var data = jsonEncode(pdata);
    try {
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: data);

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          String userId = responseData['userId'];
          String token = responseData['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString('token', token);
          print('User logged in successfully');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) {
                return Mainpage();
              }));
        } else {
          print('Failed to login user');
        }
      } else {
        print("Failed to get Data");
      }
    } catch (e) {
      print(e);
    }
  }

  static registerUser(Map pdata) async {
    var url = Uri.parse("${baseUrl}register");
    var data = jsonEncode(pdata);
    try {
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: data);

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          String userId = responseData['userId'];
          String token = responseData['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString('token', token);
          print('User registered successfully');
          return true;
        } else {
          print('Failed to register user');
          return false;
        }
      } else {
        print("Failed to get Data");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    var url = Uri.parse("${baseUrl}user-details");
    try {
      final res = await http.get(url, headers: {'Authorization': token!});
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          return responseData['user'];
        } else {
          print('Failed to fetch user details');
          return null;
        }
      } else {
        print('Error: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserDetailsById(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${baseUrl}user-details/$userId");
    try {
      final res = await http.get(url, headers: {'Authorization': token!});
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          return responseData['user'];
        } else {
          print('Failed to fetch user details');
          return null;
        }
      } else {
        print('Error: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> checkUserRegistration(String email,BuildContext context)async{
    bool? userFound =await checkUser(email, context);
    if(userFound==false){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterPage()),
      );
    }
    else if(userFound == true){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('User Already Present'),
          content: Text('This email is already registered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to check user")));
    }
  }

  static Future<void> checkUserPasswordRecover(String email,BuildContext context)async{
    bool? userFound =await checkUser(email, context);
    if(userFound==false){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Not Found")));
    }
    else if(userFound == true){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NewPassword(gmail: email,)),
      );

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to check user")));
    }
  }

  static Future<bool?> checkUser(String email, BuildContext context) async {
    var url = Uri.parse("${baseUrl}check-user?email=$email");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        print(res.body.toString());
        if (responseData['status'] == true) {
          return true;
        }
        else {
          return false;
        }
      }
      else {
        print("Failed to check user");
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> loginWithGoogle(String email,BuildContext context) async {
    var url = Uri.parse("${baseUrl}loginWithGoogle");
    var pdata = {"email":email};
    var data = jsonEncode(pdata);
    try {
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: data);
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        String userId = responseData['userId'];
        String token = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('token', token);
        print(res.body.toString());
        if (responseData['status'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Mainpage()),
          );
        }
        else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => RegisterPage()),
          );
        }
      }
      else {
        print("Failed to check user");
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Mainpage()),
      );
      print(e);
    }
  }

  static Future<void> changePassword(String currentPassword, String newPassword, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${baseUrl}change-password");
    var pdata = {"currentPassword": currentPassword, "newPassword": newPassword};
    var data = jsonEncode(pdata);
    try {
      final res = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!
          },
          body: data);
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          print('Password changed successfully');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Password changed successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          print('Failed to change password');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to change password.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        print("Failed to change password");
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> setNewPassword(String email, String newPassword, BuildContext context) async {
    var url = Uri.parse("${baseUrl}set-new-password");
    var pdata = {"email": email, "newPassword": newPassword};
    var data = jsonEncode(pdata);
    try {
      final res = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: data);
      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          print('Password reset successfully');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Password reset successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          print('Failed to reset password');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to reset password.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        print("Failed to reset password");
      }
    } catch (e) {
      print(e);
    }
  }

  static logout()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    try{
     await GoogleSignInApi.logout();}
    catch(e){
    }
    try {
      await LinkedInSignInApi.logout();
    }catch (e){}

  }
}
