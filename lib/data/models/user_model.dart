class UserModel {
  String? name;
  String? aboutYou;
  String? profileUrl;
  String? uid;
  String? email;

  UserModel({
    this.name,
    this.aboutYou,
    this.profileUrl,
    this.uid,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'aboutYou': aboutYou,
      'profileUrl': profileUrl,
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      aboutYou: map['aboutYou'] != null ? map['aboutYou'] as String : null,
      profileUrl:
          map['profileUrl'] != null ? map['profileUrl'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }
}
