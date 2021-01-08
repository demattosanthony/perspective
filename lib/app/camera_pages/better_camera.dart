import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:point_of_view/widgets/camera_widgets/camera_buttons_stack.dart';

class BetterCamera extends StatefulWidget {
  @override
  _BetterCameraState createState() => _BetterCameraState();
}

class _BetterCameraState extends State<BetterCamera>
    with WidgetsBindingObserver {
  CameraController controller;
  List<CameraDescription> cameras;
  bool flashIsOn = false;
  CameraDescription camera;

  void initController() async {
    cameras = await availableCameras();
    camera = cameras[0];
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh,
        autoFocusEnabled: true, enableAudio: true, flashMode: FlashMode.off);

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e.toString());
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void toggleFlash() async {
    FlashMode flashMode = controller.value.flashMode;

    if (flashMode == FlashMode.off) {
      setState(() {
        flashIsOn = true;
      });
      await controller.setFlashMode(FlashMode.alwaysFlash);
      setState(() {});
    } else {
      setState(() {
        flashIsOn = false;
      });
      await controller.setFlashMode(FlashMode.off);
      setState(() {});
    }
  }

  void toggleCameraDirection() async {
    if (camera == cameras[0]) {
      camera = cameras[1];
      controller = CameraController(cameras[1], ResolutionPreset.ultraHigh,
          autoFocusEnabled: true, enableAudio: true, flashMode: FlashMode.off);
    } else {
      camera = cameras[0];
      controller = CameraController(cameras[0], ResolutionPreset.ultraHigh,
          autoFocusEnabled: true, enableAudio: true, flashMode: FlashMode.off);
    }

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: controller == null
          ? Container()
          : Transform.scale(
              scale: controller.value.aspectRatio / deviceRatio,
              child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: GestureDetector(
                      onDoubleTap: toggleCameraDirection,
                      child: CameraPreview(controller)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CameraButtons(
          controller: controller,
          toggleFlash: toggleFlash,
          flashIsOn: flashIsOn,
          toggleCameraDirection: toggleCameraDirection),
    );
  }
}
