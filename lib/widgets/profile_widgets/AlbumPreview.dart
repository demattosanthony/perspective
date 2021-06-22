import 'package:flutter/material.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/album_service.dart';

import '../../locator.dart';

class AlbumPreview extends StatefulWidget {
  const AlbumPreview({Key? key}) : super(key: key);

  @override
  _AlbumPreviewState createState() => _AlbumPreviewState();
}

class _AlbumPreviewState extends State<AlbumPreview> {
  @override
  void initState() {
    super.initState();
    locator<AlbumManager>().getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: StreamBuilder<List<Album>>(
        stream: locator<AlbumManager>().getAlbums,
        builder: (context, albums) {
          if (albums.hasData) {
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (ctx, index) {
                Album album = albums.data![index];
                return Column(
                  children: [
                    FutureBuilder<String>(
                        future: locator<AlbumService>()
                            .getFirstAlbumImage(album.albumId.toString()),
                        builder: (ctx, snap) {
                          // if (snap.hasData) {
                          //   return FittedBox(
                          //       fit: BoxFit.cover,
                          //       child: Container(
                          //           height: 50,
                          //           width: 50,
                          //           child: Image.network(snap.data!)));
                          // }
                          return Container();
                        }),
                  ],
                );
              },
              itemCount: albums.data!.length,
            );
          }

          return Container();
        },
      ),
    );
  }
}
