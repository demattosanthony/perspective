import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/services/album_service.dart';

class ImageView extends StatefulWidget {
  final Photo photo;
  final int albumId;

  ImageView({@required this.photo, @required this.albumId});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool showAppBarAndBottomNavBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Visibility(
          visible: showAppBarAndBottomNavBar,
          child: PlatformAppBar(
            backgroundColor: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () {
            setState(() {
              print(widget.photo.userId);
              showAppBarAndBottomNavBar = !showAppBarAndBottomNavBar;
            });
          },
          child: showAppBarAndBottomNavBar
              ? Image.network(widget.photo.imageUrl)
              : Center(
                  child: Image.network(widget.photo.imageUrl),
                )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: showAppBarAndBottomNavBar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.photo.userId == FirebaseAuth.instance.currentUser.uid
                ? GestureDetector(
                    onTap: () {
                      showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                                title: Text(
                                    "Are you sure you want to delete this image?"),
                                actions: [
                                  PlatformDialogAction(
                                    child: Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  PlatformDialogAction(
                                    child: Text('Delete', style: TextStyle(color: Colors.red),),
                                    onPressed: () async {
                                      await locator<AlbumService>().deleteImage(
                                          widget.albumId, widget.photo.imageId);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Icon(Icons.delete, color: Colors.red)),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
