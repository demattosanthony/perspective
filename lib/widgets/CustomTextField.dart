import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextStyle style;

  CustomTextField(this.placeholder, this.controller, this.isPassword,
      [this.style = const TextStyle()]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: kIsWeb
          ? TextField(
              controller: controller,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              obscureText: isPassword ? true : false,
              decoration: InputDecoration(hintText: placeholder),
              style: style,
            )
          : Platform.isIOS
              ? CupertinoTextField(
                  placeholder: placeholder,
                  controller: controller,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  obscureText: isPassword ? true : false,
                  style: style,
                )
              : TextField(
                  controller: controller,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  obscureText: isPassword ? true : false,
                  decoration: InputDecoration(hintText: placeholder),
                  style: style,
                ),
    );
  }
}
