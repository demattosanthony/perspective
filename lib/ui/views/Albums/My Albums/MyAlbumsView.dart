import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/ui/views/Albums/My Albums/components/AlbumRow.dart';
import 'package:point_of_view/ui/views/Albums/My Albums/components/app_bar.dart';

class MyAlbumsView extends StatefulWidget {
  const MyAlbumsView({Key key}) : super(key: key);

  @override
  _MyAlbumsViewState createState() => _MyAlbumsViewState();
}

class _MyAlbumsViewState extends State<MyAlbumsView>
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
        child: MyAlbumsViewAppBar(),
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
                return AlbumRow(myAlbums: albums.data);
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
