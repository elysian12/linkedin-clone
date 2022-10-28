import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/common/constants/helper.dart';
import 'package:linkedin_clone/data/models/post_model.dart';
import 'package:linkedin_clone/data/models/user_model.dart';
import 'package:linkedin_clone/data/services/post_services.dart';
import 'package:linkedin_clone/data/services/user_service.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                    snapshot.data!.map(
                      (post) {
                        return Container(
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
                              PostBody(
                                post: post,
                              ),
                              const Divider(),
                              PostFooter(
                                post: post,
                                postServices: _postServices,
                              )
                            ],
                          ),
                        );
                      },
                    ).toList(),
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
                  Text(timeago.format(publishedAt)),
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
        ReactionButton(
          boxPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          onReactionChanged: (value) {
            log(value!);
            if (value == 'Like') {
              postServices.likePost(
                  post.postId, context.read<AuthRepository>().user!.uid!);
            }
          },
          reactions: [
            Reaction(
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.thumb_up,
                  color: AppColors.primaryBlueColor,
                ),
              ),
              value: 'Like',
            ),
            Reaction(
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.celebration,
                  color: Colors.green,
                ),
              ),
              value: 'Celebrate',
            ),
            Reaction(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.asset(
                  AssetHelper.heart,
                  height: 20,
                  color: Colors.pink,
                ),
              ),
              value: 'Heart',
            ),
          ],
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

class PostBody extends StatelessWidget {
  final Post post;
  const PostBody({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.description,
          style: textTheme.headline6,
        ),
        SizedBox(
          height: 10.h,
        ),
        post.postType == PostType.photo
            ? Image.network(post.postUrl)
            : const SizedBox.shrink(),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${post.likes.length}  Likes'),
            Text('${post.comments.length} Comments'),
          ],
        ),
      ],
    );
  }
}
