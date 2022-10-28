import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../models/post_model.dart';

class PostServices {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference _postCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  final StreamController<List<Post>> postStreamController =
      StreamController<List<Post>>.broadcast();

  DocumentSnapshot? _lastDocument;

  final List<List<Post>> _allPagedResults = <List<Post>>[];
  bool _hasMorePost = true;

  //upload a photo
  Future<String?> uploadPhoto(File file, String uuid) async {
    String? imgUrl;
    var ext = file.path.split('.').last;
    log('@@ this is extension : $ext');
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('posts/$uuid.$ext')
          .putFile(file);
      imgUrl = await storage.ref('posts/$uuid.$ext').getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.message!);
    }
    return imgUrl;
  }

  // like a post
  void likePost(String postID, String username, String likeType) async {
    try {
      var postRef = await _postCollectionReference.doc(postID).get();

      if (postRef.exists) {
        var post = Post.fromMap(postRef.data() as Map<String, dynamic>);
        if (post.likes.contains(Like(username: username))) {
          post.likes.remove(Like(username: username));
        } else {
          post.likes.add(Like(
            username: username,
            createAt: DateTime.now(),
            likeType: likeType,
          ));
        }
        postRef.reference.update({
          'likes': post.likes.map((e) => e.toMap()).toList(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  //create Post
  void createPost(Post post) async {
    try {
      await _postCollectionReference.doc(post.postId).set(post.toMap());
    } catch (e) {
      rethrow;
    }
  }

  //get more posts
  void requesMorePost() => getposts();

  //getPosts
  void getposts() async {
    await Future.delayed(const Duration(seconds: 1));
    var pagePostQuery = _postCollectionReference
        .orderBy(
          'datePublished',
          descending: true,
        )
        .limit(10);

    if (_lastDocument != null) {
      log(_lastDocument!.data().toString());
      pagePostQuery = pagePostQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMorePost) return;

    var currentRequestIndex = _allPagedResults.length;

    pagePostQuery.snapshots().listen((postSnapShot) {
      if (postSnapShot.docs.isNotEmpty) {
        var posts = postSnapShot.docs
            .map((event) => Post.fromMap(event.data() as Map<String, dynamic>))
            .toList();

        //Does the page exist or not
        var pageExist = currentRequestIndex < _allPagedResults.length;

        if (pageExist) {
          _allPagedResults[currentRequestIndex] = posts;
        } else {
          _allPagedResults.add(posts);
        }

        var allPost =
            _allPagedResults.fold<List<Post>>([], (previousValue, element) {
          return previousValue..addAll(element);
        });

        postStreamController.add(allPost);

        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = postSnapShot.docs.last;
        }

        _hasMorePost = posts.length == 10;
      }
    });
  }
}
