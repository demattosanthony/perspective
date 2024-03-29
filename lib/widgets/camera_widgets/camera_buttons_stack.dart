import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:point_of_view/widgets/camera_widgets/select_album_button.dart';
import 'package:point_of_view/widgets/camera_widgets/take_picture_button.dart';
import 'package:point_of_view/widgets/camera_widgets/toggle_camera_button.dart';
import 'package:point_of_view/widgets/camera_widgets/toggle_flash_button.dart';

class CameraButtons extends StatelessWidget {
  const CameraButtons(
      {Key? key, this.controller, this.toggleFlash, this.flashIsOn, this.toggleCameraDirection})
      : super(key: key);

  final CameraController? controller;
  final bool? flashIsOn;
  final ToggleFlashCallBack? toggleFlash;
  final ToggleCameraDirectionCallBack? toggleCameraDirection;

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
                  ToggleCameraButton(controller: controller!, toggleCameraDirection: toggleCameraDirection!, ),
                  ToggleFlashButton(
                      toggleFlash: toggleFlash!, flashIsOn: flashIsOn!)
                ],
              ),
            ),
          ),
        ),
        SelectAlbumButton(),
        TakePictureButton(controller: controller!),
      ],
    );
  }
}

typedef ToggleCameraDirectionCallBack = void Function();
