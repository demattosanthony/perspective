import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextStyle style;

  CustomTextField(this.placeholder, this.controller, this.isPassword, [this.style = const TextStyle()]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Platform.isIOS
          ? CupertinoTextField(
              placeholder: placeholder,
              controller: controller,
              autocorrect: false,
              obscureText: isPassword ? true : false,
              style: style,
            )
          : TextField(
              controller: controller,
              autocorrect: false,
              obscureText: isPassword ? true : false,
              decoration: InputDecoration(labelText: placeholder),
              style: style,
            ),
    );
  }
}
