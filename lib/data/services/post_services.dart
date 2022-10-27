import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

class PostServices {
  final CollectionReference _postCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  final StreamController<List<Post>> postStreamController =
      StreamController<List<Post>>.broadcast();

  DocumentSnapshot? _lastDocument;

  final List<List<Post>> _allPagedResults = <List<Post>>[];
  bool _hasMorePost = true;

  void likePost(String postID, String username) async {
    try {
      var postRef = await _postCollectionReference.doc(postID).get();

      if (postRef.exists) {
        var post = Post.fromMap(postRef.data() as Map<String, dynamic>);
        if (post.likes.contains(username)) {
          post.likes.remove(username);
        } else {
          post.likes.add(username);
        }
        postRef.reference.update({'likes': post.likes});
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
  void getposts() {
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
