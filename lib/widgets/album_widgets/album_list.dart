import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:optimized_cached_image/widgets.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';

class AlbumList extends StatelessWidget {
  AlbumList({this.myAlbums});
  final List<Album>? myAlbums;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myAlbums!.length,
      itemBuilder: (context, index) {
        var album = myAlbums![index];
        return Dismissible(
          key: ObjectKey(album),
          confirmDismiss: (DismissDirection direction) async {
            print(album.ownerId);
            String userId = FirebaseAuth.instance.currentUser!.uid;
            bool isOwner = userId == album.ownerId ? true : false;
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
                            onPressed: () async {
                               locator<AlbumService>()
                                  .deleteAlbum(album.albumId, isOwner);
                              locator<AlbumManager>().getAlbums();
                              Navigator.of(context).pop();
                            })
                      ],
                    ));
          },
          background: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(25)),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('albumView', arguments: album);
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                      leading: Container(
                        height: 45,
                        width: 50,
                        child: 
                        // album.profileImgUrl == ''
                             Image.asset('assets/images/profile_icon.png')
                            // : OptimizedCacheImage(
                            //     imageUrl: album.profileImgUrl,
                            //     imageBuilder: (context, imageProvider) =>
                            //         Container(
                            //       decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           image: DecorationImage(
                            //               image: imageProvider)),
                            //     ),
                            //     placeholder: (context, url) =>
                            //         Center(child: CupertinoActivityIndicator()),
                            //   ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            album.title.toUpperCase(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios)),
                ),
              )),
        );
      },
    );
  }
}
