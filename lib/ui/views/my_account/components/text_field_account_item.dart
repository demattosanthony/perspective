import 'package:flutter/material.dart';

class TextFieldAccountItem extends StatelessWidget {
  TextFieldAccountItem(
      {Key key, @required this.userData, @required this.controller})
      : super(key: key);

  final userData;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: userData,

              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
