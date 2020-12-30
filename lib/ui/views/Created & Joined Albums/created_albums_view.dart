import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';
import 'package:point_of_view/ui/views/base_view.dart';
import 'package:point_of_view/ui/views/Created & Joined Albums/components/album_row.dart';

class CreatedAlbumsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<MyAlbumsModel>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Created Albums'),
            ),
            body: FutureBuilder(
                future: model.myAlbums,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Album> albums = snapshot.data;
                    var userId = model.userId;
                    List<Album> createdAlbums = albums
                        .where((element) => element.ownerId == userId)
                        .toList();
                    return AlbumRow(
                      albums: createdAlbums,
                      getPhotos: model.getPhotos,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Container();
                })));
  }
}
