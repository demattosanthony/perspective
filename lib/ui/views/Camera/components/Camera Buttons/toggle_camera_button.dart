import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';

class ToggleCameraButton extends StatelessWidget {
  const ToggleCameraButton({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final AdvCameraController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () async {
          await controller.switchCamera();
        },
        child: Icon(
          Icons.switch_camera,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
