import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/app/album_pages/create_album_view.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/dynamic_links_service.dart';
import 'package:point_of_view/widgets/album_widgets/my_albums_app_bar.dart';
import 'package:point_of_view/widgets/album_widgets/album_list.dart';

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
    locator<AlbumManager>().getAlbums();
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
            locator<AlbumManager>().getAlbums();
          },
          child: StreamBuilder<List<Album>>(
            stream: locator<AlbumManager>().getAlbums,
            builder: (context, albums) {
              if (albums.hasData) {
                if (albums.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have no created or joined any albums yet.'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  builder: (builder) => CreateAlbumView());
                            },
                            child: Text(
                              'Create Album',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                  );
                } else
                  return AlbumList(myAlbums: albums.data);
              } else if (albums.hasError) {
                return Text("${albums.error}");
              } else if (albums.connectionState == ConnectionState.waiting) {
                return Center(child: PlatformCircularProgressIndicator());
              }

              return Container();
            },
          )),
    );
  }
}
