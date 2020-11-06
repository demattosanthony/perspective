import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../../../core/models/Event.dart';
import '../../widgets/map_widget.dart';

class ShareEventView extends StatelessWidget {
  final Event eventDetails;

  ShareEventView(this.eventDetails);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('You don\'t want to share the event?'),
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Stack(children: [
                RaisedButton(
                  onPressed: () {},
                  child: Text('test'),
                  color: Colors.black,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .30,
                  width: double.infinity,
                  child: Image.file(
                    File(eventDetails.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ]),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * .10,
                      child: Text(
                        eventDetails.title,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(Icons.date_range_rounded),
                      ),
                      title: Container(
                          child: Text('formattedDate',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      .03))),
                    ),
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
                                eventDetails.locationTitle.split(',')[0],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .03))),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(.0),
                          child: Text(eventDetails.address,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      .02)),
                        )),
                    Expanded(
                      child: MapWidget(
                        lat: double.parse(eventDetails.latitude),
                        lng: double.parse(eventDetails.longitude),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'Details',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .03),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            eventDetails.details,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * .02),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * .10,
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      onPressed: () {},
                      color: Colors.blue,
                      child: Text('Share Event',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .03)),
                      textColor: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
