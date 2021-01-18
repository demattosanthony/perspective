import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:point_of_view/widgets/camera_widgets/camera_buttons_stack.dart';
import 'package:point_of_view/widgets/camera_widgets/zoomable_widget.dart';

class BetterCamera extends StatefulWidget {
  @override
  _BetterCameraState createState() => _BetterCameraState();
}

class _BetterCameraState extends State<BetterCamera>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final xScale =
        controller == null ? 0 : controller.value.aspectRatio / deviceRatio;
// Modify the yScale if you are in Landscape
    double yScale = 1.0;
    double zoom = 1;
    double prevZoom = 1;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: controller == null
          ? Container()
          : AspectRatio(
              aspectRatio: deviceRatio,
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(xScale, yScale, 1),
                  child: GestureDetector(
                      onDoubleTap: toggleCameraDirection,
                      child: ZoomableWidget(
                          onZoom: (zoom) {
                            if (zoom < 11) {
                              controller.zoom(zoom);
                            }
                          },
                          child: CameraPreview(controller)))),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CameraButtons(
          controller: controller,
          toggleFlash: toggleFlash,
          flashIsOn: flashIsOn,
          toggleCameraDirection: toggleCameraDirection),
    );
  }
}

