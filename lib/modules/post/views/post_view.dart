import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/common/constants/colors.dart';
import 'package:linkedin_clone/data/models/post_model.dart';
import 'package:linkedin_clone/data/repositories/auth_repositories.dart';
import 'package:linkedin_clone/data/services/post_services.dart';
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
  File? photo;

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
            onPressed: () async {
              String? postUrl;
              var user = context.read<AuthRepository>().user;
              if (photo != null) {
                postUrl =
                    await PostServices().uploadPhoto(photo!, const Uuid().v4());
              }
              context.read<PostBloc>().add(
                    CreatePostEvent(
                      post: Post(
                        description: descText,
                        username: user!.uid!,
                        postId: const Uuid().v4(),
                        datePublished: DateTime.now(),
                        postUrl: photo != null ? postUrl! : '',
                        postType:
                            photo != null ? PostType.photo : PostType.text,
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
        child: SingleChildScrollView(
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
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What Do you want to talk About ?',
                    hintStyle: textTheme.headline6!
                        .copyWith(color: AppColors.grey, fontSize: 16.sp),
                  ),
                ),
                photo == null
                    ? const SizedBox.shrink()
                    : Stack(
                        children: [
                          Image.file(photo!),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  photo = null;
                                });
                              },
                              icon: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.black,
                                ),
                                child: const Icon(
                                  Icons.close_sharp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? photo =
                  await picker.pickImage(source: ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickVideo(source: ImageSource.gallery);
            },
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              // Pick an image
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                setState(() {
                  photo = File(image.path);
                });
              } else {
                EasyLoading.showError('Cancelled');
              }
            },
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
    );
  }
}
