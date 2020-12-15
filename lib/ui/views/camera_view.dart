import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'base_view.dart';

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return BaseView<CameraViewModel>(
        builder: (context, model, child) => Scaffold(
                body: FutureBuilder<void>(
              future: model.initalizeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Transform.scale(
                      scale: model.controller.value.aspectRatio / deviceRatio,
                      child: Center(
                          child: AspectRatio(
                              aspectRatio: model.controller.value.aspectRatio,
                              child: CameraPreview(model.controller))));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.camera_alt),
            ),));
  }
}
