import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/my_account/components/account_detail_row.dart';

class MyAccountView extends StatelessWidget {
  MyAccountView({this.userData});
  final userData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('My Account'),
              actions: [
                PlatformButton(
                  onPressed: () {
                    locator<UserService>().updateUserInfo(_nameController.text,
                        _usernameController.text, _emailController.text);
                  },
                  child: Text('Update'),
                )
              ],
            ),
            body: Column(
              children: [
                AccountDetailRow(
                  controller: _nameController,
                  userData: userData.name,
                  title: 'Name',
                ),
                AccountDetailRow(
                  controller: _usernameController,
                  userData: userData.username,
                  title: 'Username',
                ),
                AccountDetailRow(
                  controller: _emailController,
                  userData: userData.email,
                  title: 'Email',
                ),
              ],
            ));
  }
}
