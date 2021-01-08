import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';

class TakePictureButton extends StatelessWidget {
  const TakePictureButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: GestureDetector(
        onTap: () async {
          if (locator<CameraManager>().selectedAlbum.lastResult == null) {
            showPlatformDialog(
                context: context,
                builder: (_) =>
                    ShowAlert("Please select a Album", 'Try again.'));
          } else {
            // await controller.captureImage();
            final Directory extDir = await getApplicationDocumentsDirectory();
            final String dirPath = '${extDir.path}/Pictures/flutter_test';
            await Directory(dirPath).create(recursive: true);
            final String filePath = '$dirPath/${timestamp()}.jpg';
            await controller.takePicture(filePath);
            locator<AlbumService>().uploadImage(File(filePath),
                locator<CameraManager>().selectedAlbum.lastResult.albumId);
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

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
