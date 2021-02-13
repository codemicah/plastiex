import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SignInWithEmail({String email, String password}) async {
    final SignIn = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = SignIn.user;
    return SignIn;
  }

  Register_With_Email_password({String email, String password}) async {
    final Register = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Stream<User> userStream() {
    return _auth.authStateChanges();
  }

  Logout() async {
    await _auth.signOut();
  }
}
