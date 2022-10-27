import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/common/constants/helper.dart';

import '../../modules.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    naviagate();
    super.initState();
  }

  void naviagate() {
    //logic for auth persistance
    Future.delayed(const Duration(seconds: 1)).then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, LandingScreen.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: SvgPicture.asset(AssetHelper.logo),
        ),
      ),
    );
  }
}
