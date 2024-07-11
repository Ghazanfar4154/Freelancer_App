
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/login_screen/LoginApiHandler.dart';

class GoogleSignInApi{
  static final googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login()async {
    return await googleSignIn.signIn();
  }

  static Future<GoogleSignInAccount?> signIn(BuildContext context) async{
    final user = await GoogleSignInApi.login();
    print(user);
    if(user==null){
      print("Sign in failed");
    }else{
      LoginApiHandler.loginWithGoogle(user.email, context);
    }
    return user;
  }

  static Future<void> logout()async {
    try{
      await googleSignIn.signOut();
    }
    catch (e){

    }
  }


}