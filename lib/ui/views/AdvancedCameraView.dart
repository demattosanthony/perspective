import 'dart:io';

import 'package:adv_camera/adv_camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/viewmodels/AdvCameraModel.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';

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
            onCameraCreated: model.onMapCreated,
            onImageCaptured: (String path) {
              model.setImagePathAndUpload(path);
            },
            cameraPreviewRatio: CameraPreviewRatio.r16_9,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 90, right: 20),
              child: FloatingActionButton(
                backgroundColor: Colors.grey.withOpacity(0.30),
                onPressed: () async {
                  await model.cameraController.switchCamera();
                },
                child: Icon(
                  Icons.switch_camera,
                ),
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 90, left: 20),
                child: RaisedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        context: context,
                        builder: (builder) {
                          return ListView.builder(
                              itemCount: model.myAlbums.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    model.setSelectedAlbum(
                                        model.myAlbums[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(model.myAlbums[index].title,
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                      Divider()
                                    ],
                                  ),
                                );
                              });
                        });
                  },
                  child: Text(
                    model.selectedAlbum == null
                        ? 'Select Album'
                        : model.selectedAlbum.title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.grey.withOpacity(0.30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )),
            Container(
              alignment: FractionalOffset.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  if (model.selectedAlbum == null) {
                    showPlatformDialog(
                        context: context,
                        builder: (_) =>
                            ShowAlert("Please select a Album", 'Try again.'));
                  } else {
                    await model.cameraController.captureImage();
                  }
                },
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      color: Colors.transparent,
                      shape: BoxShape.circle),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child:
                  model.isUploading ? CircularProgressIndicator() : Container(),
            )
          ],
        ),
      ),
    );
  }
}
