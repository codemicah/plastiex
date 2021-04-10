import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/models/user.dart';
import 'package:plastiex/services/database_service.dart';
import 'package:plastiex/ui/alert.dart';
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
      // pop loader
      Navigator.pop(context);
      return SignIn;
    } catch (e) {
      Navigator.pop(context);
      Alert()
          .showAlert(isSuccess: false, message: e.toString(), context: context);
      return null;
    }
  }

  Register_With_Email_password(
      {String email, String password, BuildContext context}) async {
    try {
      loader.loading(context);

      final register = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Navigator.pop(context);

      await DatabaseService(uid: register.user.uid).updateUser(UserModel(
        uid: register.user.uid,
        displayName: "",
        email: register.user.email,
      ));

      await DatabaseService(uid: register.user.uid).createBalance();

      final User user = register.user;
    } catch (e) {
      Navigator.pop(context);
      Alert()
          .showAlert(isSuccess: false, message: e.toString(), context: context);
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
