import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/services/user_service.dart';

class ImageView extends StatefulWidget {
  final List<Photo> photos;
  final Photo photo;
  final int albumId;
  final int currentIndex;

  ImageView(
      {@required this.photo,
      @required this.albumId,
      @required this.photos,
      @required this.currentIndex});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool showAppBarAndBottomNavBar = true;
  int userId;
  // final _controller = PageController(initialPage: widget.currentIndex);

  void getUserId() async {
    var temp = await locator<UserService>().getUserIdFromSharedPrefs();
    setState(() {
      userId = temp;
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          itemCount: widget.photos.length,
          controller: PageController(initialPage: widget.currentIndex),
          itemBuilder: (context, index) {
            Photo _photo = widget.photos[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAppBarAndBottomNavBar = !showAppBarAndBottomNavBar;
                    });
                  },
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: _photo.imageUrl,
                      placeholder: (context, url) =>
                          Center(child: PlatformCircularProgressIndicator()),
                    ),
                  ),
                ),
                Positioned(
                    top: 45,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Visibility(
                        visible: showAppBarAndBottomNavBar,
                        child: Container(
                          height: 45,
                          width: 45,
                          child: Icon(Icons.arrow_back),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                    )),
                Positioned(
                    top: 45,
                    right: 20,
                    child: Visibility(
                      visible: showAppBarAndBottomNavBar,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: _photo.userProfImg == null
                            ? AssetImage('assets/images/profile_icon.png')
                            : NetworkImage(_photo.userProfImg),
                      ),
                    ))
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: showAppBarAndBottomNavBar,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.photo.userId == userId
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
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      await locator<AlbumService>().deleteImage(
                                          widget.albumId, widget.photo.imageId);
                                      await locator<AlbumManager>()
                                          .getAlbumImages(widget.albumId);
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
