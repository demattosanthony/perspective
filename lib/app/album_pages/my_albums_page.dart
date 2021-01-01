import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/widgets/my_albums_page_row.dart';
import 'package:point_of_view/widgets/my_albums_app_bar.dart';

class MyAlbumsPage extends StatefulWidget {
  const MyAlbumsPage({Key key}) : super(key: key);

  @override
  _MyAlbumsPageState createState() => _MyAlbumsPageState();
}

class _MyAlbumsPageState extends State<MyAlbumsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    locator<AlbumManager>().getAlbums();
    super.initState();
  }

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
            locator<AlbumManager>().getAlbums();
          },
          child: StreamBuilder<List<Album>>(
            stream: locator<AlbumManager>().getAlbums,
            initialData: [],
            builder: (context, albums) {
              if (albums.hasData) {
                return MyAlbumsPageRow(myAlbums: albums.data);
              } else if (albums.hasError) {
                return Text("${albums.error}");
              } else if (albums.data.isEmpty) {
                return Center(
                  child: PlatformCircularProgressIndicator(),
                );
              }

              return Container();
            },
          )),
    );
  }
}
