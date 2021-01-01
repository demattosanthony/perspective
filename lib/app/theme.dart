import 'package:flutter/material.dart';
import 'package:point_of_view/constants.dart';

ThemeData theme() {
  return ThemeData(
      fontFamily: 'Muli',
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme());
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    elevation: 0,
    textTheme:
        TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 18)),
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
  );
}

TextTheme textTheme() {
  return TextTheme(
      bodyText1: TextStyle(color: kTextColor),
      bodyText2: TextStyle(color: kTextColor));
}
