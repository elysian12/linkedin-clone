import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/data/models/post_model.dart';
import 'package:linkedin_clone/data/models/user_model.dart';
import 'package:linkedin_clone/data/services/post_services.dart';
import 'package:linkedin_clone/data/services/user_service.dart';

import '../../../data/repositories/auth_repositories.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

PostServices _postServices = PostServices();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _postServices.getposts();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leadingWidth: 70,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: CircleAvatar(
                backgroundImage: Image.network(
                        context.read<AuthRepository>().user!.profileUrl!)
                    .image,
              ),
            ),
            centerTitle: false,
            titleSpacing: 10,
            title: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.primaryBlueColor.withOpacity(0.1),
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                padding: const EdgeInsets.only(right: 20),
                onPressed: () {},
                icon: const Icon(
                  Icons.chat,
                  size: 30,
                  color: AppColors.grey,
                ),
              )
            ],
          ),
          StreamBuilder<List<Post>>(
              stream: _postServices.postStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data!
                        .map(
                          (post) => Container(
                            color: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PostHeader(
                                  uid: post.username,
                                  publishedAt: post.datePublished,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  post.description,
                                  style: textTheme.headline6,
                                ),
                                const Divider(),
                                PostFooter(
                                  post: post,
                                  postServices: _postServices,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }), // Pla
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final String uid;
  final DateTime publishedAt;
  const PostHeader({
    super.key,
    required this.uid,
    required this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<UserModel>(
        stream: UserServices().getUserStream(uid),
        builder: (context, snapshot) {
          var user = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: Image.network(user!.profileUrl!).image,
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: textTheme.headline6,
                  ),
                  Text(user.aboutYou!),
                  Text(DateFormat.Hm().format(publishedAt)),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          );
        });
  }
}

class PostFooter extends StatelessWidget {
  final Post post;
  final PostServices postServices;
  const PostFooter({
    super.key,
    required this.post,
    required this.postServices,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: EdgeInsets.only(bottom: 6),
          onPressed: () {
            postServices.likePost(
                post.postId, context.read<AuthRepository>().user!.uid!);
          },
          icon: Column(
            children: [
              Icon(
                Icons.thumb_up,
                color: post.likes
                        .contains(context.read<AuthRepository>().user!.uid!)
                    ? AppColors.primaryBlueColor
                    : null,
              ),
              Text(post.likes.length.toString())
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.comment),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }
}
