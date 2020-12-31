import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';

class CreateAlbumButton extends StatelessWidget {
  const CreateAlbumButton({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
          onPressed: () async {
            var shareString = await locator<AlbumService>().createAlbum(title);
            showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                      title: Text('Share album:\n $shareString'),
                      actions: [
                        PlatformDialogAction(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: BottomNavBar(),
                                      type: PageTransitionType.fade));
                            })
                      ],
                    ));
          },
          child: Text(
            'Create Album',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.blue),
    );
  }
}
