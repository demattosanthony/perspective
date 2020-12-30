import 'package:flutter/material.dart';

class TitleAccountItem extends StatelessWidget {
  const TitleAccountItem({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 115,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}