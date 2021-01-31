import 'dart:async';

import 'package:flutter/material.dart';
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
      await new Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.center,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: selectedPhoto.imageUrl,
          ),
        ));
  }
}
