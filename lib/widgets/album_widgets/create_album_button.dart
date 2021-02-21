import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';

class CreateAlbumButton extends StatelessWidget {
  const CreateAlbumButton({Key key, @required this.title}) : super(key: key);

  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        if (title.text != '') {
          await locator<AlbumService>().createAlbum(title.text);

          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: BottomNavBar(), type: PageTransitionType.fade));
        } else {
          print('show alert');
          // ShowAlert('Empty Album Name', "Please enter a valid album title.");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Empty Album Title!'),
                  content: Text('Please enter a valid album title.'),
                  actions: [
                    PlatformButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      },
      child: Text(
        'Create Album',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blueAccent,
    );
  }
}
