import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/widgets/CustomTextField.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';

class JoinAlbumButton extends StatelessWidget {
  const JoinAlbumButton({Key key, this.albumCodeController})
      : super(key: key);

  final TextEditingController albumCodeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
          onPressed: () {
            showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                      title: Text("Enter Album Code"),
                      content: CustomTextField(
                          "Album Code", albumCodeController, false),
                      actions: [
                        PlatformDialogAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        PlatformDialogAction(
                            child: Text("Join"),
                            onPressed: () async {
                              var responseCode =
                                  await locator<AlbumService>().joinAlbum(albumCodeController.text);
                              if (responseCode == 450) {
                                showPlatformDialog(
                                    context: context,
                                    builder: (_) => ShowAlert(
                                        "Already joined album",
                                        "Enter different code"));
                              } else if (responseCode == 200) {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: BottomNavBar(),
                                        type: PageTransitionType.fade));
                              }
                            })
                      ],
                    ));
          },
          child: Text(
            'Join Album',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          color: Colors.blue),
    );
  }
}

