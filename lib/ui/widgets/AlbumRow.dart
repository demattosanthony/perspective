import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';

class AlbumRow extends StatelessWidget {
  final List<Album> myAlbums;

  AlbumRow(this.myAlbums);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myAlbums.length,
      itemBuilder: (context, index) {
        var album = myAlbums[index];
        return GestureDetector(
          onTap: () {
            print(album.albumId);
          },
          child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      album.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}