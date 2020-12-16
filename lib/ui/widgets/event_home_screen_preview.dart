import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/models/Event.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumRow extends StatelessWidget {
  final List<Album> myAlbums;

  AlbumRow(this.myAlbums);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: myAlbums.length,
            itemBuilder: (context, index) {
              var event = myAlbums[index];
              return Card(
                  elevation: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          event.title,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ));
            },
          );
  }
}
