import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/ui/widgets/profile_icon.dart';

class AlbumRow extends StatelessWidget {
  final List<Album> myAlbums;
  final String profileImgUrl;
  final GetPhotosCallBack getPhotos;

  AlbumRow(this.myAlbums, this.profileImgUrl, this.getPhotos);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myAlbums.length,
      itemBuilder: (context, index) {
        var album = myAlbums[index];
        return GestureDetector(
          onTap: () {
            getPhotos(album.albumId);
            Navigator.of(context)
                .pushNamed('albumView', arguments: album.albumId);
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
                              backgroundImage: profileImgUrl == null
                                  ? Image()
                                  : NetworkImage(profileImgUrl)),
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
        );
      },
    );
  }
}

typedef GetPhotosCallBack = void Function(int albumId);
