import 'package:flutter/material.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/Created & Joined Albums/components/album_row.dart';
import 'package:point_of_view/core/services/user_service.dart';


class JoinedAlbumsView extends StatefulWidget {
  @override
  _JoinedAlbumsViewState createState() => _JoinedAlbumsViewState();
}

class _JoinedAlbumsViewState extends State<JoinedAlbumsView> {
  int userId;

  void getUserId() async {
    userId = await locator<UserService>().getUserIdFromSharedPrefs();
  }

  @override
  void initState() {
    locator<AlbumManager>().getAlbums();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Albums'),
      ),
      body: StreamBuilder(
          stream: locator<AlbumManager>().getAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> albums = snapshot.data;
              List<Album> joinedAlbums =
                  albums.where((element) => element.ownerId != userId).toList();
              return AlbumRow(
                albums: joinedAlbums,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Container();
          }),
    );
  }
}
