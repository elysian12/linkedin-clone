import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/common/constants/helper.dart';
import 'package:linkedin_clone/data/repositories/auth_repositories.dart';
import 'package:linkedin_clone/data/services/shared_services.dart';

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

  void naviagate() async {
    final uid = await SharedServices().getSharedUID();

    if (uid != null) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        context.read<AuthRepository>().setUser().then((value) =>
            Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.routeName, (route) => false));
      });
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, LandingScreen.routeName, (route) => false);
      });
    }
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
