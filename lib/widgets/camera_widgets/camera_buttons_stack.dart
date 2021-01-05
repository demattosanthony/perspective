
import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/widgets/camera_widgets/select_album_button.dart';
import 'package:point_of_view/widgets/camera_widgets/take_picture_button.dart';
import 'package:point_of_view/widgets/camera_widgets/toggle_camera_button.dart';
import 'package:point_of_view/widgets/camera_widgets/toggle_flash_button.dart';




class CameraButtons extends StatelessWidget {
  const CameraButtons(
      {Key key, this.controller, this.toggleFlash, this.flashIsOn})
      : super(key: key);

  final AdvCameraController controller;
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
                  ToggleFlashButton(
                      toggleFlash: toggleFlash, flashIsOn: flashIsOn)
                ],
              ),
            ),
          ),
        ),
        SelectAlbumButton(
         
        ),
        TakePictureButton(controller: controller),
        // StreamBuilder(
        //     stream: locator<CameraManager>().uploadImage.isExecuting,
        //     builder: (context, snapshot) {
        //       if (snapshot.data == true) {
        //         return Center(child: CircularProgressIndicator());
        //       }

        //       return Container();
        //     })
      ],
    );
  }
}
