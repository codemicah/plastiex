import 'package:flutter/material.dart';
import 'package:plastiex/screens/wrapper.dart';

void main() {
  runApp(PlastiexApp());
}

class PlastiexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper());
  }
}
