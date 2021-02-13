import 'package:flutter/material.dart';
import 'package:plastiex/ui/colors.dart';

class CustomAppBar extends StatelessWidget {
  final Color color;
  final String title;
  final List<Widget> items;

  CustomAppBar({this.title, this.color, this.items = const []});

  @override
  Widget build(BuildContext context) {
    List<Widget> _appBarItems = [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: white,
        ),
      ),
    ];

    for (int i = 0; i < items.length; i++) {
      _appBarItems.add(items[i]);
    }

    return Container(
        color: color,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _appBarItems,
          ),
        ));
  }
}
