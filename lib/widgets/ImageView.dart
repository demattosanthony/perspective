import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:optimized_cached_image/widgets.dart';
import 'package:point_of_view/models/Photo.dart';
import 'delete_image_button.dart';

class ImageView extends StatefulWidget {
  final List<Photo> ?photos;
  final Photo? photo;
  final int? albumId;
  final int? currentIndex;

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
  // final _controller = PageController(initialPage: widget.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          itemCount: widget.photos!.length,
          controller: PageController(initialPage: widget.currentIndex!),
          itemBuilder: (context, index) {
            Photo _photo = widget.photos![index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAppBarAndBottomNavBar = !showAppBarAndBottomNavBar;
                    });
                  },
                  child: 
                  // _photo.imageUrl.isNotEmpty
                      // ? Center(
                      //     child: Container(
                      //     child: OptimizedCacheImage(
                      //       imageUrl: _photo.imageUrl,
                      //       placeholder: (context, url) => Center(
                      //           child: PlatformCircularProgressIndicator()),
                      //       fadeInDuration: Duration(seconds: 0),
                      //     ),
                      //   ))
                      Container(),
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
                // Positioned(
                //     top: 45,
                //     right: 20,
                //     child: Visibility(
                //       visible: showAppBarAndBottomNavBar,
                //       child: Container(
                //           height: 52,
                //           width: 52,
                //           child: OptimizedCacheImage(
                //             imageUrl: _photo.userProfImg,
                //             imageBuilder: (context, imageProvider) => Container(
                //               decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   image: DecorationImage(image: imageProvider)),
                //             ),
                //             placeholder: (context, url) => Center(
                //                 child: PlatformCircularProgressIndicator()),
                //           )),
                //     )),
                Positioned(
                  bottom: 25,
                  left: 0,
                  right: 0,
                  child: Visibility(
                      visible: _photo.userId ==
                          FirebaseAuth.instance.currentUser!.uid,
                      child: DeleteImageButton(
                        widget: widget,
                        photo: _photo,
                      )),
                )
              ],
            );
          }),
    );
  }
}
