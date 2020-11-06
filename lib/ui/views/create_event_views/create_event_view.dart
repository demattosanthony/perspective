import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:point_of_view/core/viewmodels/create_event_model.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/widgets/map_widget.dart';
import '../base_view.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import '../../widgets/date_picker.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class CreateEventView extends StatelessWidget {
  PlatformMapController mapController;

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateEventModel>(
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
                                Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BottomNavBar(0)),
                              ModalRoute.withName('/'),
                            ),
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    )) ??
                    false;
              },
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: PlatformAppBar(
                    title: Text("New Event"),
                    trailingActions: [
                      GestureDetector(
                        onTap: () => model.createEventInDb(context),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text('Create Event'),
                        ),
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .20,
                          child: model.image != null
                              ? GestureDetector(
                                  onTap: model.getImage,
                                  child: Image(
                                      fit: BoxFit.fill,
                                      image: FileImage(File(model.image))),
                                )
                              : RaisedButton(
                                  onPressed: model.getImage,
                                  child: Text(
                                    'Select Event Image',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  color: Colors.white,
                                )),
                      TextField(
                        controller: model.eventTextFieldController,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .035,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Event Title',
                            hintStyle: TextStyle(fontSize: 20),
                            contentPadding: EdgeInsets.all(20)),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      DatePicker(
                        selectDate: model.selectDate,
                        selectTime: model.selectTime,
                        startDate: model.selectedStartDate,
                        endDate: model.selectedEndDate,
                        endTime: model.selectedEndTime,
                        startTime: model.selectedStartTime,
                      ),
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
                                            child: Icon(
                                                Icons.navigate_next_rounded))),
                                  )),
                            )
                          : GestureDetector(
                              onTap: () async {
                                final result =
                                    await model.addLocationButton(context);
                                mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target:
                                                LatLng(result[0], result[1]),
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
                                              model.locationAddress
                                                  .split(',')[0],
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
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
                                    height: MediaQuery.of(context).size.height *
                                        .18,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                      child: Card(
                                        elevation: 10,
                                        child: PlatformMap(
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                  double.parse(model.latitude),
                                                  double.parse(
                                                      model.longitude)),
                                              zoom: 15),
                                          onMapCreated: (controller) {
                                            mapController = controller;
                                            mapController.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                    CameraPosition(
                                                        target: LatLng(
                                                            double.parse(
                                                                model.latitude),
                                                            double.parse(model
                                                                .longitude)),
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
                                                    double.parse(
                                                        model.latitude),
                                                    double.parse(
                                                        model.longitude)),
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
                      Container(
                        height: MediaQuery.of(context).size.height * .08,
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: model.eventDetailsController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add Details...',
                              hintStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
