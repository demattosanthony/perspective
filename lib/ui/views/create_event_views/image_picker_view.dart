import 'package:flutter/material.dart';
import 'package:local_image_provider/device_image.dart';
import 'dart:io';

import 'package:point_of_view/core/viewmodels/image_picker_model.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'create_event_view.dart';
import 'package:page_transition/page_transition.dart';
import '../../../core/models/file.dart';
import 'package:local_image_provider/local_album.dart';


class ImagePickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ImagePickerModel>(
        builder: (context, model, child) => WillPopScope(
              onWillPop: () async {
                (await showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text('Do you want to close event'),
                        actions: <Widget>[
                          new FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No'),
                          ),
                          new FlatButton(
                            onPressed: () =>
                                Navigator.of(context).pushReplacementNamed('/'),
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    )) ??
                    false;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('tets'),
                  centerTitle: true,
                  actions: [
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Text(
                          'Next',
                        ),
                        onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                child: CreateEventView(),
                                type: PageTransitionType.rightToLeftWithFade)),
                      ),
                    )
                  ],
                ),
                body: SafeArea(
                  child: Column(children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        child: model.image != null
                            ? Image(image: DeviceImage(model.image), fit: BoxFit.cover,)
                            : Container()),
                    Divider(
                      height: 2,
                    ),
                    model.selectedModel == null 
                        ? Container()
                        : Container(
                            height: MediaQuery.of(context).size.height * .35,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4),
                              itemBuilder: (_, i) {
                                var file = model.files[i];
                                return GestureDetector(
                                  child: Image(image: DeviceImage(file), fit: BoxFit.cover,),
                                  onTap: () {
                                    model.setImage(file);
                                  },
                                );
                              },
                              itemCount: model.files.length
                            ),
                          )
                  ]),
                ),
              ),
            ));
  }
}
