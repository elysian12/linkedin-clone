class Post {
  final String description;
  final String username;
  final List<String> likes;
  final List<Comment> comments;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final PostType postType;

  Post({
    required this.description,
    required this.username,
    this.likes = const [],
    this.comments = const [],
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.postType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'username': username,
      'likes': likes.map((x) => x).toList(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'postId': postId,
      'datePublished': datePublished.millisecondsSinceEpoch,
      'postUrl': postUrl,
      'postType': postType.name,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      description: map['description'] as String,
      username: map['username'] as String,
      likes: List<String>.from((map['likes'] as List).map((e) => e).toList()),
      comments: List<Comment>.from(
          (map['comments'] as List).map((e) => Comment.fromMap(e)).toList()),
      postId: map['postId'] as String,
      datePublished:
          DateTime.fromMillisecondsSinceEpoch(map['datePublished'] as int),
      postUrl: map['postUrl'] as String,
      postType: getPostType(map['postType']),
    );
  }

  static PostType getPostType(String? text) {
    Map<String, PostType> map = {
      'PHOTO': PostType.photo,
      'VIDEO': PostType.video,
      'AUDIO': PostType.audio,
      'LINK': PostType.link,
      'TEXT': PostType.text,
    };
    return map[text] ?? PostType.photo;
  }
}

class Like {
  final String username;
  final DateTime createAt;

  Like({
    required this.username,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'createAt': createAt.millisecondsSinceEpoch,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      username: map['username'] as String,
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
    );
  }
}

class Comment {
  final String username;
  final String body;
  final DateTime createAt;

  Comment({
    required this.username,
    required this.createAt,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'body': body,
      'createAt': createAt.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      username: map['username'] as String,
      body: map['body'] as String,
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
    );
  }
}

enum PostType { photo, video, audio, link, text }
