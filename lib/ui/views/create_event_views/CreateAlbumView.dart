import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:point_of_view/core/viewmodels/CreateAlbumModel.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/widgets/CustomTextField.dart';
import 'package:point_of_view/ui/widgets/map_widget.dart';
import '../base_view.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import '../../widgets/date_picker.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class CreateAlbumView extends StatelessWidget {
  PlatformMapController mapController;

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAlbumModel>(
        builder: (context, model, child) => Container(
              height: MediaQuery.of(context).size.height * .90,
              child: Column(
                children: [
                  // Container(
                  //     width: double.infinity,
                  //     height: MediaQuery.of(context).size.height * .20,
                  //     child: model.image != null
                  //         ? GestureDetector(
                  //             onTap: model.getImage,
                  //             child: Image(
                  //                 fit: BoxFit.fill,
                  //                 image: FileImage(File(model.image))),
                  //           )
                  //         : RaisedButton(
                  //             onPressed: model.getImage,
                  //             child: Text(
                  //               'Select Event Image',
                  //               style: TextStyle(
                  //                   color: Colors.black, fontSize: 20),
                  //             ),
                  //             color: Colors.white,
                  //           )),
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
                  model.selectedLocation == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * .08,
                          child: GestureDetector(
                              onTap: () {
                                model.addLocationButton(context);
                              },
                              child: ListTile(
                                leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 34,
                                      minHeight: 34,
                                      maxWidth: 34,
                                      maxHeight: 34,
                                    ),
                                    child: Image.asset(
                                      'assets/grey_location_icon.png',
                                    )),
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Add Location',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                trailing: new SizedBox(
                                    width: 25,
                                    height: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child:
                                            Icon(Icons.navigate_next_rounded))),
                              )),
                        )
                      : GestureDetector(
                          onTap: () async {
                            final result =
                                await model.addLocationButton(context);

                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(result[0], result[1]),
                                    zoom: 15)));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                  leading: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 34,
                                        minHeight: 34,
                                        maxWidth: 34,
                                        maxHeight: 34,
                                      ),
                                      child: Image.asset(
                                        'assets/grey_location_icon.png',
                                      )),
                                  title: Container(
                                      child: Text(
                                          model.locationAddress.split(',')[0],
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .03))),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(.0),
                                    child: Text(model.locationAddress,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .02)),
                                  )),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .18,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                  child: Card(
                                    elevation: 10,
                                    child: PlatformMap(
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              double.parse(model.latitude),
                                              double.parse(model.longitude)),
                                          zoom: 15),
                                      onMapCreated: (controller) {
                                        mapController = controller;
                                        mapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        double.parse(
                                                            model.latitude),
                                                        double.parse(
                                                            model.longitude)),
                                                    zoom: 15)));
                                      },
                                      zoomControlsEnabled: false,
                                      scrollGesturesEnabled: false,
                                      myLocationEnabled: false,
                                      markers: Set<Marker>.of(
                                        [
                                          Marker(
                                            markerId: MarkerId('marker_1'),
                                            position: LatLng(
                                                double.parse(model.latitude),
                                                double.parse(model.longitude)),
                                            consumeTapEvents: true,
                                            infoWindow: InfoWindow(
                                              title: 'Event Location',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  Divider(
                    thickness: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        onPressed: () async {
                          await model.createAlbum();
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: BottomNavBar(),
                                  type: PageTransitionType.fade));
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
