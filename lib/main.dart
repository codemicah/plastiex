import 'package:flutter/material.dart';

void main() {
  runApp(PlastiexApp());
}

class PlastiexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Plastiex'),
          ),
          body: Center(
            child: Text('Welcome'),
          ),
        ));
  }
}
