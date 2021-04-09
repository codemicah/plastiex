import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastiex/ui/colors.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: white,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Welcome",
                style: TextStyle().copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text("To "),
                  Text(
                    "Plastiex",
                    style: TextStyle().copyWith(
                      color: primaryColor,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(2.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
