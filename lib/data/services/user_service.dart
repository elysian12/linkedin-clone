import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserServices {
  final _userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  void createProfile(UserModel user) async {
    try {
      await _userCollectionReference.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<UserModel?> getProfile(String uid) async {
    UserModel? user;
    try {
      var doc = await _userCollectionReference.doc(uid).get();

      if (doc.exists) {
        user = UserModel.fromMap(doc.data()!);
      } else {
        user = null;
      }
    } on FirebaseException catch (_) {
      user = null;
      rethrow;
    }
    return user;
  }

  Stream<UserModel> getUserStream(String uid) {
    return _userCollectionReference.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
