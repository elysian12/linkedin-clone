// file to create your app theme and stuff

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.primaryColor,
    textTheme: textTheme(),
  );
}

TextTheme textTheme() {
  return TextTheme(
      headline5: TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  ));
}
