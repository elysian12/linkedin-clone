import 'package:flutter/material.dart';

class JobsScreen extends StatelessWidget {
  static const String routeName = "/jobs";

  const JobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Jobs Screen'),
      ),
    );
  }
}
