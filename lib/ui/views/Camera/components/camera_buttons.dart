import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/Camera/components/Camera%20Buttons/select_album_button.dart';
import 'package:point_of_view/ui/views/Camera/components/Camera%20Buttons/take_picture_button.dart';
import 'package:point_of_view/ui/views/Camera/components/Camera%20Buttons/toggle_camera_button.dart';
import 'package:point_of_view/ui/views/Camera/components/Camera%20Buttons/toggle_flash_button.dart';

class CameraButtons extends StatelessWidget {
  const CameraButtons(
      {Key key,
      this.controller,
      this.isUploading,
      this.myAlbums,
      this.selectedAlbum,
      this.setSelectedAlbum,
      this.toggleFlash,
      this.flashIsOn})
      : super(key: key);

  final AdvCameraController controller;
  final List<Album> myAlbums;
  final Album selectedAlbum;
  final bool isUploading;
  final SetSelectedAlbumCallBack setSelectedAlbum;
  final bool flashIsOn;
  final ToggleFlashCallBack toggleFlash;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 20,
          top: 75,
          child: FittedBox(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.30)),
              child: Column(
                children: [
                  ToggleCameraButton(controller: controller),
                  ToggleFlashButton(toggleFlash: toggleFlash, flashIsOn: flashIsOn)
                ],
              ),
            ),
          ),
        ),
        SelectAlbumButton(
            myAlbums: locator<AlbumManager>().getAlbums.lastResult,
            setSelectedAlbum: setSelectedAlbum,
            selectedAlbum: selectedAlbum),
        TakePictureButton(selectedAlbum: selectedAlbum, controller: controller),
        Container(
          alignment: Alignment.center,
          child: isUploading ? CircularProgressIndicator() : Container(),
        ),
      ],
    );
  }
}


