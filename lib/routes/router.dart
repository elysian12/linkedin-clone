import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../modules/modules.dart';

class MyRouter {
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Route Not Defined'),
        ),
      );
    });
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    log(settings.name!);
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return null;
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      //auth
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case LandingScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      default:
        return _errorRoute();
    }
  }
}
