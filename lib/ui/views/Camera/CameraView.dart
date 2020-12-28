import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'package:point_of_view/ui/components/ShowAlert.dart';
import '../base_view.dart';
import 'dart:io';
import 'package:path/path.dart' show join;

class CameraView extends StatelessWidget {
  const CameraView({Key key}) : super(key: key);
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
                                      GestureDetector(
                                        onDoubleTap: () => model.cameraToggle(),
                                        child: CameraPreview(model.controller))
                                    ]))),
                            SafeArea(
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 75, left: 50),
                                  child: RaisedButton(
                                    color: Colors.grey.withOpacity(.30),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          context: context,
                                          builder: (builder) {
                                            return ListView.builder(
                                                itemCount:
                                                    model.myAlbums.length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      model.setSelectedAlbum(
                                                          model
                                                              .myAlbums[index]);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              model
                                                                  .myAlbums[
                                                                      index]
                                                                  .title,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
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
                                          ? "Select Album"
                                          : model.selectedAlbum.title,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 115, right: 50),
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  model.cameraToggle();
                                },
                                child: Icon(Icons.flip_camera_ios_outlined),
                                backgroundColor: Colors.grey.withOpacity(0.30),
                              ),
                            ),
                            model.isUploading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container()
                          ],
                        ));
                  } else {
                    return Container();
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
                    if (model.selectedAlbum == null) {
                      showPlatformDialog(
                          context: context,
                          builder: (_) =>
                              ShowAlert("Please select a Album", 'Try again.'));
                    } else {
                      try {
                        await model.initalizeControllerFuture;

                        final path = join(
                            //store in tmp directory
                            //find tmp firectory using path_provider
                            (await getTemporaryDirectory()).path,
                            '${DateTime.now()}.png');

                        await model.controller.takePicture(path);

                        model.uploadImage(File(path));

                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                ),
              ),
            ));
  }
}
