import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';

class TakePictureButton extends StatefulWidget {
  TakePictureButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final CameraController controller;

  @override
  _TakePictureButtonState createState() => _TakePictureButtonState();
}

class _TakePictureButtonState extends State<TakePictureButton> {
  bool isUploading = false;

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
            setState(() {
              isUploading = true;
            });
            // await controller.captureImage();
            final Directory extDir = await getApplicationDocumentsDirectory();
            final String dirPath = '${extDir.path}/Pictures/flutter_test';
            await Directory(dirPath).create(recursive: true);
            final String filePath = '$dirPath/${timestamp()}.png';
            await widget.controller.takePicture(filePath);
            locator<AlbumService>().uploadImage(File(filePath),
                locator<CameraManager>().selectedAlbum.lastResult.albumId);
            setState(() {
              isUploading = false;
            });
          }
        },
        child: isUploading
            ? Container(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(),
              )
            : Container(
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
