import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plastiex/screens/wrapper.dart';
import 'package:plastiex/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PlastiexApp());
}

class PlastiexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: primaryTheme,
      home: Wrapper(),
    );
  }
}
