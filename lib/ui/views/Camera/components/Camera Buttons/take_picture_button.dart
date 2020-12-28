import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';

class TakePictureButton extends StatelessWidget {
  const TakePictureButton({
    Key key,
    @required this.selectedAlbum,
    @required this.controller,
  }) : super(key: key);

  final Album selectedAlbum;
  final AdvCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: GestureDetector(
        onTap: () async {
          if (selectedAlbum == null) {
            showPlatformDialog(
                context: context,
                builder: (_) =>
                    ShowAlert("Please select a Album", 'Try again.'));
          } else {
            await controller.captureImage();
          }
        },
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              color: Colors.transparent,
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}