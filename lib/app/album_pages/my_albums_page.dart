import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/my_albums_app_bar.dart';
import 'package:point_of_view/widgets/my_albums_page_row.dart';

class MyAlbumsPage extends StatefulWidget {
  const MyAlbumsPage({Key key}) : super(key: key);

  @override
  _MyAlbumsPageState createState() => _MyAlbumsPageState();
}

class _MyAlbumsPageState extends State<MyAlbumsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAlbumsAppBar(),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            // locator<AlbumManager>().getAlbums();
          },
          child: StreamBuilder<List<Album>>(
            stream: locator<AlbumService>().getAlbums(),
            builder: (context, albums) {
              if (albums.hasData) {
                return MyAlbumsPageRow(
                  myAlbums: albums.data,
                );
              } else if (albums.hasError) {
                return Text("${albums.error}");
              }

              return Container();
            },
          )),
    );
  }
}
