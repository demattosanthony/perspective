import 'package:flutter/material.dart';

import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  PlatformMapController mapController;
  String locationAddress;
  final LocationPickerCallBack selectLoc;

  MapWidget(
      {this.lat,
      this.lng,
      this.mapController,
      this.locationAddress,
      this.selectLoc});

  void _onMapCreated(PlatformMapController controller) {
    mapController = controller;

    print('ANIMATINGGGG camera');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await selectLoc(context);
        print('Resullttt' + result.toString());
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(result[0], result[1]), zoom: 15)));
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
                  child: Text(locationAddress.split(',')[0],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .03))),
              subtitle: Padding(
                padding: const EdgeInsets.all(.0),
                child: Text(locationAddress,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * .02)),
              )),
          Container(
            height: MediaQuery.of(context).size.height * .18,
            width: double.infinity,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              child: Card(
                elevation: 10,
                child: PlatformMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, lng), zoom: 15),
                  onMapCreated: _onMapCreated,
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  myLocationEnabled: false,
                  markers: Set<Marker>.of(
                    [
                      Marker(
                        markerId: MarkerId('marker_1'),
                        position: LatLng(lat, lng),
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
          ),
        ],
      ),
    );
  }
}

typedef LocationPickerCallBack = Future<List> Function(BuildContext context);
