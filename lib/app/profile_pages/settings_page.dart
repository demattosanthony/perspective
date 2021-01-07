import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [
            PlatformButton(
              child:
                  Text('Delete account', style: TextStyle(color: Colors.red)),
              onPressed: () {
                showPlatformDialog(
                    context: context,
                    builder: (_) => PlatformAlertDialog(
                          title: Text(
                              'Are you sure you want to delete your account?'),
                          actions: [
                            PlatformDialogAction(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop()),
                            PlatformDialogAction(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  String resCode = await locator<UserService>()
                                      .deleteAccount();
                                  if (resCode == 'requires-recent-login') {
                                    showPlatformDialog(
                                        context: context,
                                        builder: (_) => ShowAlert(
                                            'Requires recent login.',
                                            'Log out and log back in, then you will be able to delete account'));
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed('loginView');
                                  }
                                })
                          ],
                        ));
              },
            )
          ],
        ));
  }
}
