import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';

class CreateAlbumButton extends StatelessWidget {
  const CreateAlbumButton({Key key, @required this.title}) : super(key: key);

  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
          onPressed: () async {
            await locator<AlbumService>().createAlbum(title.text);

            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: BottomNavBar(), type: PageTransitionType.fade));
          },
          child: Text(
            'Create Album',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.blue),
    );
  }
}
