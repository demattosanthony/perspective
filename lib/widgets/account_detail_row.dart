import 'package:flutter/material.dart';

class AccountDetailRow extends StatelessWidget {
  AccountDetailRow(
      {Key? key, this.title, @required this.userData, @required this.controller})
      : super(key: key);

  final userData;
  final String? title;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 115,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Expanded(
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
        )
      ],
    );
  }
}
