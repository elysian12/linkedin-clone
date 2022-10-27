import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';
import '../constants/helper.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
    required this.width,
    this.onTap,
    required this.textTheme,
  }) : super(key: key);

  final double width;
  final TextTheme textTheme;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        minimumSize: Size(width * 0.8, 45.h),
        maximumSize: Size(width * 0.8, 45.h),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.black),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetHelper.google,
            height: 30,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            'Continue with Google',
            style: textTheme.headline5!.copyWith(
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
