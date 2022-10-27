import 'package:flutter/material.dart';

class NetworkScreen extends StatelessWidget {
  static const String routeName = "/network";

  const NetworkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Network Screen'),
      ),
    );
  }
}
