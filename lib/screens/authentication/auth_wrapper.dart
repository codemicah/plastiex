import 'package:flutter/material.dart';
import 'package:plastiex/screens/authentication/signin.dart';
import 'package:plastiex/screens/authentication/signup.dart';

class AuthWrapper extends StatelessWidget {
  final ValueNotifier<bool> _showSignIn = ValueNotifier(true);

  bool toggleAuth() {
    return _showSignIn.value = !_showSignIn.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _showSignIn,
      builder: (context, _, __) {
        if (_showSignIn.value)
          return LoginScreen(toggleAuth: toggleAuth);
        else
          return RegisterScreen(toggleAuth: toggleAuth);
      },
    );
  }
}
