import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/common/constants/helper.dart';
import 'package:linkedin_clone/modules/modules.dart';

import '../../../common/widgets/widgets.dart';
import '../../../data/blocs/blocs.dart';

class LandingScreen extends StatelessWidget {
  static const String routeName = "/landing";

  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthErrorState) {
              EasyLoading.showError(state.error);
            }
            if (state is AuthLoadingState) {
              EasyLoading.show(status: 'loading...');
            }
            if (state is AuthenticatedState) {
              EasyLoading.showSuccess('Success!');
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainScreen.routeName,
                (route) => false,
              );
            }
          },
          child: SizedBox(
            width: w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    AssetHelper.longLogo,
                    height: 50,
                  ),
                  const Spacer(),
                  Text(
                    'Join a trusted community of 800M professionals',
                    style: textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    height: 45.h,
                    width: w * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'Join Now',
                      style: textTheme.headline5!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GoogleButton(
                    width: w,
                    textTheme: textTheme,
                    onTap: () {
                      context.read<AuthBloc>().add(LoginEvent());
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign In',
                      style: textTheme.headline5!.copyWith(
                        color: AppColors.primaryBlueColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
