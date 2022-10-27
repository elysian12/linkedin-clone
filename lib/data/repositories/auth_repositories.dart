import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_clone/data/models/user_model.dart';
import 'package:linkedin_clone/data/services/shared_services.dart';
import 'package:linkedin_clone/data/services/user_service.dart';

import '../../firebase_options.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final SharedServices sharedServices;
  final UserServices userServices;
  AuthRepository({
    required this.auth,
    required this.sharedServices,
    required this.userServices,
  });

  UserModel? user;

  //SignIn With Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    Map<String, dynamic> results = {};

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
      ).signIn();

      if (googleUser == null) {
        results.addAll({'error': 'Cancelled'});
        return results;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredentail = await auth.signInWithCredential(credential);

      if (userCredentail.user != null) {
        sharedServices.setSharedUID(userCredentail.user!.uid);

        var user = await userServices.getProfile(userCredentail.user!.uid);
        if (user == null) {
          userServices.createProfile(
            UserModel(
                name: userCredentail.user!.displayName,
                uid: userCredentail.user!.uid,
                profileUrl: userCredentail.user!.photoURL,
                email: userCredentail.user!.email,
                aboutYou: 'Hey there 👋 ${userCredentail.user!.displayName}'),
          );
        } else {
          this.user = user;
        }
        results.addAll({'success': true});
      }
    } on FirebaseAuthException catch (e) {
      results.addAll({'error': e.message!});
    }

    return results;
  }

  Future<void> setUser() async {
    user =
        await userServices.getProfile(FirebaseAuth.instance.currentUser!.uid);
  }
}
