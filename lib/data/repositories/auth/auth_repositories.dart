import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_clone/data/services/shared_services.dart';

import '../../../firebase_options.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final SharedServices sharedServices;
  const AuthRepository({
    required this.auth,
    required this.sharedServices,
  });

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
        results.addAll({'success': true});
      }
    } on FirebaseAuthException catch (e) {
      results.addAll({'error': e.message!});
    }

    return results;
  }
}
