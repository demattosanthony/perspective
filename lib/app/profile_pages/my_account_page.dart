import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:point_of_view/widgets/account_detail_row.dart';

class MyAccountPage extends StatelessWidget {
  MyAccountPage({this.userData});
  final UserAccount? userData;

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
              onPressed: () async {
                String response = await locator<UserService>().updateUserInfo(
                    _nameController.text,
                    _usernameController.text,
                    _emailController.text);

                if (response == 'username-taken') {
                  showPlatformDialog(
                      context: context,
                      builder: (_) =>
                          ShowAlert('Username is taken', 'Try again'));
                } else if (response == 'failed') {
                  showPlatformDialog(
                      context: context,
                      builder: (_) => ShowAlert(
                          'Could not upload changes', 'Try again later'));
                } else if (response == 'success') {
                  showPlatformDialog(
                      context: context,
                      builder: (_) => ShowAlert('Update Complete', ''));
                  locator<UserManager>().getUserInfo();
                  Future.delayed(Duration(seconds: 1));
                }
              },
              child: Text('Update'),
            )
          ],
        ),
        body: Column(
          children: [
            AccountDetailRow(
              controller: _nameController,
              userData: userData!.name,
              title: 'Name',
            ),
            AccountDetailRow(
              controller: _usernameController,
              userData: userData!.username,
              title: 'Username',
            ),
            // AccountDetailRow(
            //   controller: _emailController,
            //   userData: userData.email,
            //   title: 'Email',
            // ),
          ],
        ));
  }
}
