
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const baseUrl = "http://192.168.1.7:3000/";

final loadingAnimation = Center(
  child: Lottie.asset(
      'assets/animations/loading_animation.json', // Path to your loading animation
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      repeat: true
  ),
);


final noDataAnimation = Center(
    child: Lottie.asset(
      'assets/animations/noData_animation1.json', // Path to your no data animation
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      repeat: true
    ));

Color whiteColor = Colors.white;

Color cyanColor = Colors.teal;

Color logoColor = Colors.deepOrangeAccent;

Color logoTitleColor = Colors.white;
