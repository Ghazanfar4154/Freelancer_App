import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';
import 'package:untitled/login_screen/LoginApiHandler.dart';

class LinkedInSignInApi{

  static final _linkedInConfig = LinkedInConfig(
    clientId: '78bs8sliffoyjn',
    clientSecret: 'WPL_AP1.aBlcfpTJTvJHmAK6.pi9WSg==',
    redirectUrl: 'https://www.youtube.com/callback',
    scope: ['openid', 'profile', 'email'],
  );
  static LinkedInUser? _linkedInUser;


  static void signin(BuildContext context){

    SignInWithLinkedIn.signIn(
      context,
      config: _linkedInConfig,
      onGetUserProfile: (tokenData, user) {
        log('Auth token data: ${tokenData.toJson()}');
        log('LinkedIn User: ${user.toJson()}');
         _linkedInUser = user;
         LoginApiHandler.loginWithGoogle(user.email!, context);
      },
      onSignInError: (error) {
        log('Error on sign in: $error');
      },
    );
  }

  static Future<void> logout()async {
    try{
      await SignInWithLinkedIn.logout();
    }
    catch (e){

    }
  }
}