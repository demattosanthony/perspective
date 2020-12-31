import 'dart:io';

import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/managers/camera_manager.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/services/ApiService.dart';

import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/Camera/components/camera_buttons.dart';

// ignore: must_be_immutable
class AdvCameraView extends StatefulWidget {
  const AdvCameraView({Key key}) : super(key: key);
  @override
  _AdvCameraViewState createState() => _AdvCameraViewState();
}

class _AdvCameraViewState extends State<AdvCameraView> {
  AdvCameraController _cameraController;
  Album _selctedAlbum;
  bool isUploading = false;
  String imagePath;
  bool _flashIsOn = false;

  void _onCameraCreated(AdvCameraController cameraController) {
    setState(() {
      _cameraController = cameraController;
      _cameraController.setFlashType(FlashType.off);
    });
  }

  void setSelectedAlbum(album) {
    setState(() {
      _selctedAlbum = album;
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

  void uploadImage(File image) async {
    setState(() {
      isUploading = true;
    });

    var reponseCode = await locator<ApiService>()
        .uploadImage(image, _selctedAlbum.title, _selctedAlbum.albumId);

    setState(() {
      if (reponseCode != null) isUploading = false;
    });
  }

  void setImagePathAndUpload(String path) {
    setState(() {
      imagePath = path;
    });

    uploadImage(File(imagePath));
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
            setImagePathAndUpload(path);
          },
          cameraPreviewRatio: CameraPreviewRatio.r16_9,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CameraButtons(
        controller: _cameraController,
        isUploading: isUploading,
        selectedAlbum: _selctedAlbum,
        setSelectedAlbum: setSelectedAlbum,
        toggleFlash: toggleFlash,
        flashIsOn: _flashIsOn,
      ),
    );
  }
}
