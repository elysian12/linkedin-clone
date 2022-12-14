import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_clone/data/blocs/auth/auth_bloc.dart';
import 'package:linkedin_clone/data/blocs/bottombloc/bottombloc_bloc.dart';
import 'package:linkedin_clone/data/blocs/post/post_bloc.dart';
import 'package:linkedin_clone/data/repositories/auth_repositories.dart';
import 'package:linkedin_clone/data/services/shared_services.dart';
import 'package:linkedin_clone/data/services/user_service.dart';

import './common/constants/theme.dart';
import './modules/modules.dart';
import './routes/router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => AuthRepository(
                auth: FirebaseAuth.instance,
                sharedServices: SharedServices(),
                userServices: UserServices(),
              ),
            )
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                ),
              ),
              BlocProvider(
                create: (context) => PostBloc(),
              ),
              BlocProvider(
                create: (context) => BottomBloc()
                  ..add(
                    const ChangePageEvent(pageIndex: 0),
                  ),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "LinkedIn Clone App",
              theme: appTheme(),
              builder: EasyLoading.init(),
              onGenerateRoute: MyRouter.generateRoute,
              initialRoute: SplashScreen.routeName,
            ),
          ),
        );
      },
    );
  }
}
