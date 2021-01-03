import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:point_of_view/widgets/selected_album_app_bar.dart';
import 'package:point_of_view/widgets/image_grid_item.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:http/http.dart' as http;

class SelectedAlbumPage extends StatefulWidget {
  const SelectedAlbumPage({this.album});

  final Album album;

  @override
  _SelectedAlbumPageState createState() => _SelectedAlbumPageState();
}

class _SelectedAlbumPageState extends State<SelectedAlbumPage> {
  bool isSelectingImages = false;

  void setSelectingImages() {
    setState(() {
      isSelectingImages = !isSelectingImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SelectedAlbumAppBar(
          album: widget.album,
          isSelecting: isSelectingImages,
          setSelectingImages: setSelectingImages,
        ),
      ),
      body: StreamBuilder<List<Photo>>(
        stream: locator<AlbumService>().getPhotos(widget.album.albumId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orientation = MediaQuery.of(context).orientation;
            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 4 : 3),
                itemBuilder: (context, index) {
                  String imageUrl = snapshot.data[index].imageUrl;
                  bool isSelected = snapshot.data[index].isSelected;
                  int imageId = snapshot.data[index].photoId;
                  return ImageGridItem(
                    imageUrl: imageUrl,
                    isSelectingImages: isSelectingImages,
                    isSelected: isSelected,
                    imageId: imageId,
                  );
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: Container(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
                final result = await ImageGallerySaver.saveImage(
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
      ),
    );
  }
}
