import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:point_of_view/app/album_pages/selected_album_page.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:http/http.dart' as http;


class SelectedAlbumBottomNavBar extends StatelessWidget {
  const SelectedAlbumBottomNavBar({
    Key key,
    @required this.widget,
    @required this.isSelectingImages,
  }) : super(key: key);

  final SelectedAlbumPage widget;
  final bool isSelectingImages;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      fixedColor: Colors.blueAccent,
      unselectedItemColor: Colors.blueAccent,
      currentIndex: 0,
      onTap: (index) async {
        if (index == 2) {
          var photos = await FirebaseFirestore.instance
              .collection("albums")
              .doc(widget.album.albumId)
              .collection("photos")
              .get();
          try {
            for (var photo in photos.docs) {
              var response = await http.get(photo['imageUrl']);
              final _ = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(response.bodyBytes),
                  quality: 60,
                  name: "hello");
            }
          } catch (e) {
            throw Exception('Could no download album');
          }

          showPlatformDialog(
              context: context,
              builder: (_) => ShowAlert("Download Complete!", "Success"));
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded), label: 'Upload Images'),
        BottomNavigationBarItem(
            icon: Icon(Icons.download_rounded),
            label: isSelectingImages ? 'Download Images' : 'Download Album')
      ],
    );
  }
}
