import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:point_of_view/widgets/account_detail_row.dart';

class MyAccountPage extends StatelessWidget {
  MyAccountPage({this.userData});
  final UserAccount userData;

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
                // var success = await locator<UserService>().updateUserInfo(
                //     _nameController.text,
                //     _usernameController.text,
                //     _emailController.text);

                // showPlatformDialog(
                //     context: context,
                //     builder: (_) => ShowAlert(
                //         success ? 'Upload Success' : 'Could not upload changes',
                //         success ? '' : 'Try again later'));

                // locator<UserManager>().getUserInfo();
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
