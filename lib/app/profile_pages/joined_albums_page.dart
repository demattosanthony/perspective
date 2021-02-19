import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/widgets/album_widgets/album_list.dart';

class JoinedAlbumsPage extends StatefulWidget {
  @override
  _JoinedAlbumsPageState createState() => _JoinedAlbumsPageState();
}

class _JoinedAlbumsPageState extends State<JoinedAlbumsPage> {
  @override
  void initState() {
    super.initState();
    locator<AlbumManager>().getAlbums();
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
              List<Album> joinedAlbums = albums
                  .where((element) =>
                      element.ownerId != FirebaseAuth.instance.currentUser.uid)
                  .toList();
              return AlbumList(
                myAlbums: joinedAlbums,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Container();
          }),
    );
  }
}
