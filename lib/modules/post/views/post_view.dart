import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/data/models/post_model.dart';
import 'package:linkedin_clone/data/repositories/auth_repositories.dart';
import 'package:uuid/uuid.dart';

import '../../../data/blocs/post/post_bloc.dart';

class PostScreen extends StatefulWidget {
  static const String routeName = "/post";

  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late TextEditingController desc;

  String descText = '';

  @override
  void initState() {
    super.initState();
    desc = TextEditingController();
  }

  @override
  void dispose() {
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
        centerTitle: false,
        title: Text(
          'Share Post',
          style: textTheme.headline5!.copyWith(
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 80,
            padding: const EdgeInsets.only(left: 10),
            onPressed: () {
              var user = context.read<AuthRepository>().user;
              context.read<PostBloc>().add(
                    CreatePostEvent(
                      post: Post(
                        description: descText,
                        username: user!.uid!,
                        postId: const Uuid().v4(),
                        datePublished: DateTime.now(),
                        postUrl: '',
                        postType: PostType.text,
                      ),
                    ),
                  );
            },
            icon: Text(
              'Post',
              style: textTheme.headline5!.copyWith(
                fontSize: 18.sp,
                color: desc.text.isEmpty
                    ? AppColors.grey
                    : AppColors.primaryBlueColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostLoadingState) {
            EasyLoading.show(status: 'loading...');
          }
          if (state is PostErrorState) {
            EasyLoading.showError(state.error);
          }
          if (state is CreatePostSucessState) {
            EasyLoading.showSuccess('Created!')
                .then((value) => Navigator.pop(context));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: Image.network(
                            context.read<AuthRepository>().user!.profileUrl!)
                        .image,
                  ),
                ],
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    descText = value;
                  });
                },
                controller: desc,
                style: textTheme.headline6,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'What Do you want to talk About ?',
                  hintStyle: textTheme.headline6!
                      .copyWith(color: AppColors.grey, fontSize: 16.sp),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.videocam),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.photo),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 80,
                    onPressed: () {},
                    icon: const Text('Anyone'),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
