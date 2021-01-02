import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';

import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/album_row_created_joined.dart';
import 'package:point_of_view/services/user_service.dart';

class CreatedAlbumsPage extends StatefulWidget {
  @override
  _CreatedAlbumsPageState createState() => _CreatedAlbumsPageState();
}

class _CreatedAlbumsPageState extends State<CreatedAlbumsPage> {
  int userId;

  void getUserId() async {
    userId = 42;
  }

  @override
  void initState() {
    // locator<AlbumManager>().getAlbums();
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Created Albums'),
        ),
        body: StreamBuilder(
            stream: locator<AlbumService>().getAlbums(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Album> albums = snapshot.data;
                List<Album> createdAlbums = albums
                    .where((element) => element.ownerId == userId)
                    .toList();
                return AlbumRow(
                  albums: createdAlbums,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Container();
            }));
  }
}
