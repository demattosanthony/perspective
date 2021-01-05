import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/album_widgets/album_list.dart';

class CreatedAlbumsPage extends StatefulWidget {
  @override
  _CreatedAlbumsPageState createState() => _CreatedAlbumsPageState();
}

class _CreatedAlbumsPageState extends State<CreatedAlbumsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Created Albums'),
        ),
        body: StreamBuilder(
            stream: locator<AlbumService>().getCreatedAlbums(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Album> albums = snapshot.data;
                String userId = FirebaseAuth.instance.currentUser.uid;
                List<Album> createdAlbums = albums
                    .where((element) => element.ownerId == userId)
                    .toList();
                return AlbumList(
                  myAlbums: createdAlbums,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Container();
            }));
  }
}
