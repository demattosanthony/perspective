import 'package:flutter/material.dart';
import 'package:point_of_view/constants.dart';

ThemeData theme() {
  return ThemeData(fontFamily: 'Muli', scaffoldBackgroundColor: Colors.white);
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor)
  );
}
