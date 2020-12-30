import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumRow extends StatelessWidget {
  final List<Album> myAlbums;
  final GetPhotosCallBack getPhotos;
  final DeleteAlbumCallBack deleteAlbum;
  final GetAlbumsCallBack getAlbums;

  AlbumRow(this.myAlbums, this.getPhotos, this.deleteAlbum, this.getAlbums);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myAlbums.length,
      itemBuilder: (context, index) {
        var album = myAlbums[index];
        return Dismissible(
          key: ObjectKey(album),
          confirmDismiss: (DismissDirection direction) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var userId = prefs.getInt('userId');
            var isOwner = userId == album.ownerId ? true : false;
            return showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                      title: isOwner
                          ? Text(
                              "Are you sure you want to delete this album and all of its photos?")
                          : Text('Are you sure you want to leave this album?'),
                      content: Text("This action can not be undone."),
                      actions: [
                        PlatformDialogAction(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop()),
                        PlatformDialogAction(
                            child: isOwner
                                ? Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text('Leave',
                                    style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              deleteAlbum(album.albumId, isOwner);
                              myAlbums.remove(album);
                              Navigator.of(context).pop();
                            })
                      ],
                    ));
          },
          background: Container(
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(25)),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: GestureDetector(
            onTap: () async {
              getPhotos(album.albumId);
              Navigator.of(context).pushNamed('albumView', arguments: album);
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
                                backgroundImage: album.profileImgUrl == 'null'
                                    ? AssetImage('assets/profile_icon.png')
                                    : NetworkImage(album.profileImgUrl)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                album.title.toUpperCase(),
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
typedef DeleteAlbumCallBack = void Function(int albumId, bool isOwner);
typedef GetAlbumsCallBack = void Function();
