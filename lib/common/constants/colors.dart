import 'package:flutter/material.dart';

class AppColors {
  //define appcolors
  static const Color primaryColor = Colors.white;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color primaryBlueColor = Color(0xff0F4FB5);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xff0077B5),
      Color(0xff0E6795),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
