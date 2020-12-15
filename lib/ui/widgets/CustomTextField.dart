import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;

  CustomTextField(this.placeholder, this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Platform.isIOS ? CupertinoTextField(
        placeholder: placeholder,
        controller: controller,
        autocorrect: false,
      ) : TextField(
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(labelText: placeholder),
      ),
    );
  }
}
