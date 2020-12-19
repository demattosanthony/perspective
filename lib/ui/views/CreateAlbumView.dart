import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:point_of_view/core/viewmodels/CreateAlbumModel.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/widgets/CustomTextField.dart';
import 'package:point_of_view/ui/widgets/ShowAlert.dart';
import 'package:point_of_view/ui/widgets/map_widget.dart';
import 'base_view.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class CreateAlbumView extends StatelessWidget {
  PlatformMapController mapController;

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAlbumModel>(
        builder: (context, model, child) => Container(
              height: MediaQuery.of(context).size.height * .90,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * .10,
                      child: CustomTextField(
                          'Album Title',
                          model.albumTitleController,
                          false,
                          TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        onPressed: () {
                          showPlatformDialog(
                              context: context,
                              builder: (_) => PlatformAlertDialog(
                                    title: Text("Enter Album Code"),
                                    content: CustomTextField("Album Code",
                                        model.albumCodeController, false),
                                    actions: [
                                      PlatformDialogAction(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      PlatformDialogAction(
                                          child: Text("Join"),
                                          onPressed: () async {
                                            var responseCode =
                                                await model.joinAlbum(model
                                                    .albumCodeController.text);
                                            if (responseCode == 450) {
                                              showPlatformDialog(
                                                  context: context,
                                                  builder: (_) => ShowAlert(
                                                      "Already joined album",
                                                      "Enter different code"));
                                            } else if (responseCode == 200) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: BottomNavBar(),
                                                      type: PageTransitionType
                                                          .fade));
                                            }
                                          })
                                    ],
                                  ));
                        },
                        child: Text(
                          'Join Album',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Colors.blue),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        onPressed: () async {
                          var shareString = await model.createAlbum();
                          showPlatformDialog(
                              context: context,
                              builder: (_) => PlatformAlertDialog(
                                    title: Text('Share album:\n $shareString'),
                                    actions: [
                                      PlatformDialogAction(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                PageTransition(
                                                    child: BottomNavBar(),
                                                    type: PageTransitionType
                                                        .fade));
                                          })
                                    ],
                                  ));
                        },
                        child: Text(
                          'Create Album',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.blue),
                  ),
                ],
              ),
            ));
  }
}
