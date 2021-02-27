import 'dart:async';

import 'package:flutter/material.dart';
import 'package:optimized_cached_image/widgets.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../locator.dart';

class SlideshowPage extends StatefulWidget {
  Album album;
  SlideshowPage(this.album);
  @override
  _SlideshowPageState createState() => _SlideshowPageState();
}

class _SlideshowPageState extends State<SlideshowPage> {
  Photo selectedPhoto;
  List<Photo> photos;
  bool endSlideshow = false;
  bool showBackButton = true;

  void getPhotos() {
    photos = locator<AlbumManager>().getAlbumImages.lastResult;
  }

  @override
  void initState() {
    getPhotos();
    startSlideshow();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startSlideshow() async {
    for (var photo in photos) {
      if (this.mounted)
        setState(() {
          selectedPhoto = photo;
        });
      await new Future.delayed(const Duration(seconds: 6));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showBackButton = !showBackButton;
                });
              },
              child: Container(
                  alignment: Alignment.center,
                  child: OptimizedCacheImage(
                    imageUrl: selectedPhoto.imageUrl,
                    fadeInDuration: Duration(seconds: 4),
                    fadeOutDuration: Duration(seconds: 3),
                  )),
            ),
            Visibility(
              visible: showBackButton,
              child: Positioned(
                top: 50,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    child: Icon(Icons.arrow_back),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
