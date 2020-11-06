import 'package:flutter/material.dart';

import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  PlatformMapController mapController;

  MapWidget({this.lat, this.lng});

  void _onMapCreated(PlatformMapController controller) {
    mapController = controller;
    //LatLng(35.969591, -79.993357)

    print('ANIMATINGGGG camera');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
