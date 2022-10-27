import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../firebase_options.dart';

class AuthRepository {
  final FirebaseAuth auth;
  const AuthRepository({
    required this.auth,
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
        results.addAll({'success': true});
      }
    } on FirebaseAuthException catch (e) {
      results.addAll({'error': e.message!});
    }

    return results;
  }
}
