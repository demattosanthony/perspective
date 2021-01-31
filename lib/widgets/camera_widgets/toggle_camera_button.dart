import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:point_of_view/widgets/camera_widgets/camera_buttons_stack.dart';

class ToggleCameraButton extends StatelessWidget {
  const ToggleCameraButton(
      {Key key, @required this.controller, this.toggleCameraDirection})
      : super(key: key);

  final CameraController controller;
  final ToggleCameraDirectionCallBack toggleCameraDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () async {
          // await controller.switchCamera();
          toggleCameraDirection();
        },
        child: Icon(
          Icons.flip_camera_ios,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
