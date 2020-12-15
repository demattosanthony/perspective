import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ShowAlert extends StatelessWidget {
  final String title;
  final String content;

  ShowAlert(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          PlatformDialogAction(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
