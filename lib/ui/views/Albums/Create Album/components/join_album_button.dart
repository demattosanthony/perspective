import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/ui/components/CustomTextField.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';

class JoinAlbumButton extends StatelessWidget {
  const JoinAlbumButton({Key key, this.albumCodeController, this.joinAlbum})
      : super(key: key);

  final TextEditingController albumCodeController;
  final JoinAlbumCallback joinAlbum;

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
                                  await joinAlbum(albumCodeController.text);
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

typedef JoinAlbumCallback = Future<int> Function(String shareString);