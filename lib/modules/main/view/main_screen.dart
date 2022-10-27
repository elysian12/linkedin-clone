import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/modules/modules.dart';

import '../../../data/blocs/bottombloc/bottombloc_bloc.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = "/main";

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomBloc, BottomBlocState>(
        builder: (context, state) {
          if (state is BottomNavigationCurrentState) {
            return IndexedStack(
              index: state.currentIndex,
              children: const [
                HomeScreen(),
                NetworkScreen(),
                PostScreen(),
                NotificationScreen(),
                JobsScreen()
              ],
            );
          }
          return const Center(
            child: Text('Something went Wrong'),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomBloc, BottomBlocState>(
        builder: (context, state) {
          if (state is BottomNavigationCurrentState) {
            return Container(
              color: AppColors.primaryColor,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(5, (index) {
                  bool isActive = state.currentIndex == index;
                  return InkWell(
                    onTap: () {
                      if (index == 2) {
                        Navigator.pushNamed(context, PostScreen.routeName);
                      } else {
                        context
                            .read<BottomBloc>()
                            .add(ChangePageEvent(pageIndex: index));
                      }
                    },
                    child: index == 0
                        ? _buildBottomNavigationItem(
                            isActive, 'Home', Icons.home)
                        : index == 1
                            ? _buildBottomNavigationItem(
                                isActive, 'Network', Icons.people)
                            : index == 2
                                ? _buildBottomNavigationItem(
                                    isActive, 'Post', Icons.add)
                                : index == 3
                                    ? _buildBottomNavigationItem(
                                        isActive,
                                        'Notification',
                                        Icons.notifications_active)
                                    : _buildBottomNavigationItem(
                                        isActive, 'Jobs', Icons.cases_rounded),
                  );
                }),
              ),
            );
          }
          return const Center(
            child: Text('Something went Wrong'),
          );
        },
      ),
    );
  }

  _buildBottomNavigationItem(bool isAcive, String label, IconData iconData) {
    return Column(
      children: [
        isAcive
            ? Container(
                height: 4,
                width: 50,
                color: AppColors.black,
              )
            : const SizedBox(
                height: 4,
                width: 50,
              ),
        const SizedBox(
          height: 10,
        ),
        Icon(
          iconData,
          color: isAcive ? AppColors.black : null,
        ),
        Text(
          label,
          // style: TextStyle(fontSize: 9.sp),
        ),
      ],
    );
  }
}
