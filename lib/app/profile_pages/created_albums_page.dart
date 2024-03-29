import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/widgets/album_widgets/album_list.dart';

class CreatedAlbumsPage extends StatefulWidget {
  @override
  _CreatedAlbumsPageState createState() => _CreatedAlbumsPageState();
}

class _CreatedAlbumsPageState extends State<CreatedAlbumsPage> {
  @override
  void initState() {
    super.initState();
    locator<AlbumManager>().getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Created Albums'),
        ),
        body: StreamBuilder<List<Album>>(
            stream: locator<AlbumManager>().getAlbums,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Album> albums = snapshot.data!;

                List<Album> createdAlbums = albums
                    .where((element) =>
                        element.ownerId ==
                        FirebaseAuth.instance.currentUser!.uid)
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
