import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/ui/widgets/profile_icon.dart';
import 'package:flutter/foundation.dart';

class AlbumRow extends StatelessWidget {
  final List<Album> myAlbums;
  final GetPhotosCallBack getPhotos;
  final DeleteAlbumCallBack deleteAlbum;
  final GetAlbumsCallBack getAlbums;

  AlbumRow(this.myAlbums, this.getPhotos, this.deleteAlbum,
      this.getAlbums);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myAlbums.length,
      itemBuilder: (context, index) {
        var album = myAlbums[index];
        return Dismissible(
          key: ObjectKey(album),
          onDismissed: (direction) async {
            deleteAlbum(album.albumId);
            myAlbums.remove(album);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              getPhotos(album.albumId);
              Navigator.of(context)
                  .pushNamed('albumView', arguments: album);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                backgroundImage: album.profileImgUrl == null
                                    ? Image()
                                    : NetworkImage(album.profileImgUrl)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                album.title,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

typedef GetPhotosCallBack = void Function(int albumId);
typedef DeleteAlbumCallBack = void Function(int albumId);
typedef GetAlbumsCallBack = void Function();
