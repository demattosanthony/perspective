import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/album_row_created_joined.dart';
import 'package:point_of_view/services/user_service.dart';

class JoinedAlbumsPage extends StatefulWidget {
  @override
  _JoinedAlbumsPageState createState() => _JoinedAlbumsPageState();
}

class _JoinedAlbumsPageState extends State<JoinedAlbumsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Albums'),
      ),
      body: StreamBuilder(
          stream: locator<AlbumService>().getAlbums(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Album> albums = snapshot.data;
              String userId = FirebaseAuth.instance.currentUser.uid;
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