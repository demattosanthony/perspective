import 'dart:async';

import 'package:flutter/material.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/services/dynamic_links_service.dart';
import 'package:point_of_view/widgets/my_albums_app_bar.dart';
import 'package:point_of_view/widgets/album_list.dart';
import 'package:rxdart/rxdart.dart';

class MyAlbumsPage extends StatefulWidget {
  const MyAlbumsPage({Key key}) : super(key: key);

  @override
  _MyAlbumsPageState createState() => _MyAlbumsPageState();
}

class _MyAlbumsPageState extends State<MyAlbumsPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(const Duration(milliseconds: 1000), () {
        _dynamicLinkService.retreieveDynamicLink(context);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

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
            locator<AlbumService>().getCreatedAlbums();
          },
          child: StreamBuilder(
            stream: CombineLatestStream.list([
              locator<AlbumService>().getCreatedAlbums(),
              locator<AlbumService>().getJoinedAlbums()
            ]),
            builder: (context, albums) {
              List<Album> createdAndJoinedAlbums =
                  albums.data[0] + albums.data[1];
              if (albums.hasData) {
                return AlbumList(
                  myAlbums: createdAndJoinedAlbums,
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
