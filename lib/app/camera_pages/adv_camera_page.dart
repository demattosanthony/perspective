import 'dart:io';

import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/camera_buttons_stack.dart';

class AdvCameraPage extends StatefulWidget {
  const AdvCameraPage({Key key}) : super(key: key);
  @override
  _AdvCameraPageState createState() => _AdvCameraPageState();
}

class _AdvCameraPageState extends State<AdvCameraPage> {
  AdvCameraController _cameraController;
  bool _flashIsOn = false;
  PermissionStatus cameraPermissionStatus;

  void _onCameraCreated(AdvCameraController cameraController) {
    setState(() {
      _cameraController = cameraController;
      _cameraController.setFlashType(FlashType.off);
    });
  }

  void toggleFlash() {
    setState(() {
      if (!_flashIsOn) {
        _flashIsOn = true;
        _cameraController.setFlashType(FlashType.on);
      } else {
        _flashIsOn = false;
        _cameraController.setFlashType(FlashType.off);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () async {
          await _cameraController.switchCamera();
        },
        child: AdvCamera(
          cameraSessionPreset: CameraSessionPreset.high,
          initialCameraType: CameraType.rear,
          onCameraCreated: _onCameraCreated,
          onImageCaptured: (String path) {
            locator<AlbumService>().uploadImage(File(path), locator<CameraManager>().selectedAlbum.lastResult.albumId);
          },
          cameraPreviewRatio: CameraPreviewRatio.r16_9,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CameraButtons(
        controller: _cameraController,
        toggleFlash: toggleFlash,
        flashIsOn: _flashIsOn,
      ),
    );
  }
}
