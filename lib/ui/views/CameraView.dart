import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_view/core/models/Album.dart';
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
              backgroundColor: Colors.black,
              body: FutureBuilder<void>(
                future: model.initalizeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Transform.scale(
                        scale: model.controller.value.aspectRatio / deviceRatio,
                        child: Stack(
                          children: [
                            Center(
                                child: AspectRatio(
                                    aspectRatio:
                                        model.controller.value.aspectRatio,
                                    child: Stack(children: [
                                      CameraPreview(model.controller)
                                    ]))),
                            SafeArea(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 75, left: 50),
                                  child: DropdownButton<Album>(
                                    value: model.selctedAlbumTitle,
                                    dropdownColor: Colors.transparent,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    hint: Text(
                                      "Select Album",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    items: model.myAlbums.map((value) {
                                      return new DropdownMenuItem<Album>(
                                        value: value,
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .45,
                                            child: new Text(value.title)),
                                      );
                                    }).toList(),
                                    onChanged: (Album newValue) {
                                      model.setSelectedAlbum(newValue);
                                      print(newValue.albumId);
                                    },
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 120, right: 50),
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  model.cameraToggle();
                                },
                                child: Icon(Icons.flip_camera_ios_outlined),
                                backgroundColor: Colors.grey.withOpacity(0.30),
                              ),
                            )
                          ],
                        ));
                  } else {
                    return Center(
                      child: PlatformCircularProgressIndicator(),
                    );
                  }
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  heroTag: "TakePictureBtn",
                  backgroundColor: Colors.transparent,
                  
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        color: Colors.transparent,
                        shape: BoxShape.circle),
                  ),
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
