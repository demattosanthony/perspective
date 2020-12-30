import 'package:flutter/material.dart';
import 'package:point_of_view/ui/views/my_account/components/text_field_account_item.dart';
import 'package:point_of_view/ui/views/my_account/components/title_account_item.dart';

class AccountDetailRow extends StatelessWidget {
  AccountDetailRow(
      {Key key, this.title, @required this.userData, @required this.controller})
      : super(key: key);

  final userData;
  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TitleAccountItem(
          title: title,
        ),
        TextFieldAccountItem(controller: controller, userData: userData)
      ],
    );
  }
}
