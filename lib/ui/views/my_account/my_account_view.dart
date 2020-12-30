import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/my_account_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/views/my_account/components/account_detail_row.dart';

class MyAccountView extends StatelessWidget {
  MyAccountView({this.userData});
  final userData;

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAccountModel>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('My Account'),
              actions: [
                PlatformButton(
                  onPressed: () {
                    model.updateUserInfo();
                  },
                  child: Text('Update'),
                )
              ],
            ),
            body: Column(
              children: [
                AccountDetailRow(
                  controller: model.nameController,
                  userData: userData.name,
                  title: 'Name',
                ),
                AccountDetailRow(
                  controller: model.usernameController,
                  userData: userData.username,
                  title: 'Username',
                ),
                AccountDetailRow(
                  controller: model.emailController,
                  userData: userData.email,
                  title: 'Email',
                ),
              ],
            )));
  }
}
