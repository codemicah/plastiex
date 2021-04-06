import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/ui/loader.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SignInWithEmail({String email, String password, BuildContext context}) async {
    try {
      // show loader
      loader.loading(context);

      final SignIn = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pop(context);
      final User user = SignIn.user;
      return SignIn;
    } catch (e) {
      Navigator.pop(context);
      return null;
    }
  }

  Register_With_Email_password(
      {String email, String password, BuildContext context}) async {
    try {
      loader.loading(context);

      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // DatabaseService(uid: user.)
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      return null;
    }
  }

  Stream<User> userStream() {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
