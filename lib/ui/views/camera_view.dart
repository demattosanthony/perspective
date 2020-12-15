import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'base_view.dart';
import 'dart:io';
import 'package:path/path.dart' show join;

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
                onPressed: () async {
                  try {
                    await model.initalizeControllerFuture;

                    final path = join(
                        //store in tmp directory
                        //find tmp firectory using path_provider
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png');

                    await model.controller.takePicture(path);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                                  imagePath: path,
                                )));
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ));
  }
}

//A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
