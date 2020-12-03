import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Event.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventHomeScreenPreview extends StatelessWidget {
  final List<Event> myEvents;

  EventHomeScreenPreview(this.myEvents);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myEvents.length,
      itemBuilder: (context, index) {
        var event = myEvents[index];
        return Card(
            elevation: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child: CachedNetworkImage(imageUrl: event.image)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    event.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
                  child: Text(
                    'Start: ${event.startDate} at ${event.startTime}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
                  child: Text(
                    'End: ${event.endDate} at ${event.endTime}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ));
      },
    );
  }
}
