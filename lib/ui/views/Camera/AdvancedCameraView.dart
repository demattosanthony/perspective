
import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';

import 'package:point_of_view/core/viewmodels/AdvCameraModel.dart';
import 'package:point_of_view/ui/views/Camera/components/camera_buttons.dart';
import 'package:point_of_view/ui/views/base_view.dart';

class AdvCameraView extends StatelessWidget {
  const AdvCameraView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<AdvCameraModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onDoubleTap: () async {
            await model.cameraController.switchCamera();
          },
          child: AdvCamera(
          
            cameraSessionPreset: CameraSessionPreset.high,
            initialCameraType: CameraType.rear,
            onCameraCreated: model.onCameraCreated,
            onImageCaptured: (String path) {
              model.setImagePathAndUpload(path);
              
            },
            cameraPreviewRatio: CameraPreviewRatio.r16_9,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CameraButtons(
          controller: model.cameraController,
          isUploading: model.isUploading,
          myAlbums: model.myAlbums,
          selectedAlbum: model.selectedAlbum,
          setSelectedAlbum: model.setSelectedAlbum,
          toggleFlash: model.toggleFlash,
          flashIsOn: model.flashIsOn,
        ),
      ),
    );
  }
}


