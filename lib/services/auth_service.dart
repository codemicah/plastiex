import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/user.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/ui/alert.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignInWithEmail({String email, String password, BuildContext context}) async {
    try {
      final SignIn = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignIn;
    } on FirebaseAuthException catch (e) {
      Alert().showAlert(isSuccess: false, message: e.message, context: context);
      return null;
    }
  }

  Register_With_Email_password(
      {String email, String password, BuildContext context}) async {
    try {
      final register = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await DatabaseService(uid: register.user.uid).updateUser(UserModel(
        uid: register.user.uid,
        displayName: "",
        email: register.user.email,
      ));

      await DatabaseService(uid: register.user.uid).createBalance();
    } on FirebaseAuthException catch (e) {
      Alert().showAlert(isSuccess: false, message: e.message, context: context);
      return null;
    }
  }

  Stream<User> userStream() {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }
}
