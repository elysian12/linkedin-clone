// file to create your app theme and stuff

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.grey.withOpacity(0.1),
    textTheme: textTheme(),
    iconTheme: const IconThemeData(color: AppColors.grey),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.black),
    ),
  );
}

TextTheme textTheme() {
  return TextTheme(
    headline5: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    ),
    headline6: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    ),
  );
}
