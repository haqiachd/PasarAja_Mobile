import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSignService extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  /// sign in as anonymous
  Future<void> signInAsAnonymous() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      Logger().i(
          'Signed in with anonymous account -> UID : ${credential.user?.uid}');
    } catch (ex) {
      Logger().e(ex.toString());
    }
  }

  Future googleLogin() async {
    try {
      // reset akun
      _user = null;
      notifyListeners();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      Logger().e(e);
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
