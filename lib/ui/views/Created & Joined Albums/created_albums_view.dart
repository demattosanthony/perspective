import 'package:flutter/material.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/models/Album.dart';

import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/Created & Joined Albums/components/album_row.dart';
import 'package:point_of_view/core/services/user_service.dart';

class CreatedAlbumsView extends StatefulWidget {
  @override
  _CreatedAlbumsViewState createState() => _CreatedAlbumsViewState();
}

class _CreatedAlbumsViewState extends State<CreatedAlbumsView> {
  int userId;

  void getUserId() async {
    userId = await locator<UserService>().getUserIdFromSharedPrefs();
  }

  @override
  void initState() {
    locator<AlbumManager>().getAlbums();
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
            stream: locator<AlbumManager>().getAlbums,
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
