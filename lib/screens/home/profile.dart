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
              shape: BoxShape.rectangle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: white,
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                SizedBox(height: 5.0),
                Text("N5,000")
              ],
            ),
          )
        ],
      ),
    );
  }
}
