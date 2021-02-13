import 'package:flutter/material.dart';
import 'package:plastiex/ui/appbar.dart';
import 'package:plastiex/ui/colors.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAppBar(
            title: "Profile",
            color: shallowGreen,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: shallowGreen,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
            ),
            child: CircleAvatar(
              radius: 40,
            ),
          )
        ],
      ),
    );
  }
}
