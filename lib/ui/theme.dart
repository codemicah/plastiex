import 'package:flutter/material.dart';
import 'package:plastiex/ui/colors.dart';

ThemeData primaryTheme = ThemeData(
  scaffoldBackgroundColor: white,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 20.0, color: Colors.black),
    bodyText2: TextStyle(fontSize: 18.0, color: Colors.black),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle().copyWith(color: Colors.black),
    errorBorder:
        OutlineInputBorder().copyWith(borderSide: BorderSide(color: red)),
    border: OutlineInputBorder()
        .copyWith(borderSide: BorderSide(color: primaryColor)),
    focusedBorder: OutlineInputBorder()
        .copyWith(borderSide: BorderSide(color: primaryColor)),
  ),
);
