import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  static const String routeName = "/post";

  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Post Screen'),
      ),
    );
  }
}
