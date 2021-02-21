import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:point_of_view/app/album_pages/selected_album_page.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/services/dynamic_links_service.dart';
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

import '../locator.dart';

class SelectedAlbumBottomNavBar extends StatefulWidget {
  SelectedAlbumBottomNavBar({
    Key key,
    @required this.widget,
    @required this.isSelectingImages,
    @required this.album,
  }) : super(key: key);

  final SelectedAlbumPage widget;
  final bool isSelectingImages;
  final Album album;

  @override
  _SelectedAlbumBottomNavBarState createState() =>
      _SelectedAlbumBottomNavBarState();
}

class _SelectedAlbumBottomNavBarState extends State<SelectedAlbumBottomNavBar> {
  var currentIndex = 0;
  int userId;
  bool showDelete = false;

  void getUserId() async {
    if (FirebaseAuth.instance.currentUser.uid == widget.album.ownerId) {
      setState(() {
        showDelete = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelectingImages) {
      return Container(
        height: 85,
        padding: EdgeInsets.only(bottom: 15),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: !showDelete
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () async {
                List<Photo> _photos =
                    locator<AlbumManager>().getSelectedImages();
                try {
                  for (var photo in _photos) {
                    var response = await http.get(photo.imageUrl);
                    await ImageGallerySaver.saveImage(
                        Uint8List.fromList(response.bodyBytes),
                        quality: 60,
                        name: "hello");
                  }
                  showPlatformDialog(
                      context: context,
                      builder: (_) =>
                          ShowAlert("Download Complete!", "Success"));
                } catch (e) {
                  throw Exception('Could no download album');
                }
              },
              child: Icon(
                Icons.download_rounded,
                color: Colors.blue,
                size: 40,
              ),
              backgroundColor: Colors.transparent,
            ),
            Visibility(
              visible: showDelete,
              child: FloatingActionButton(
                onPressed: () async {
                  List<Photo> _photos =
                      locator<AlbumManager>().getSelectedImages();
                  try {
                    for (var photo in _photos) {
                      await locator<AlbumService>()
                          .deleteImage(widget.album.albumId, photo.imageId);
                      await locator<AlbumManager>()
                          .getAlbumImages(widget.album.albumId);
                    }
                  } catch (e) {
                    throw Exception('Could not delete images');
                  }
                },
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        fixedColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueAccent,
        currentIndex: 0,
        onTap: (index) async {
          if (index == 2) {
            // Download entire album
            var photos = locator<AlbumManager>().getAlbumImages.lastResult;
            try {
              for (var photo in photos) {
                var response = await http.get(photo.imageUrl);
                final _ = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(response.bodyBytes),
                    quality: 60,
                    name: "hello");
              }

              showPlatformDialog(
                  context: context,
                  builder: (_) => ShowAlert("Download Complete!", "Success"));
            } catch (e) {
              throw Exception('Could no download album');
            }
          } else if (index == 0) {
            Uri shareUrl = await locator<DynamicLinkService>()
                .createDynamicLink(widget.album.albumId.toString(),
                    widget.album.title, widget.album.ownerId);
            Share.share(shareUrl.toString(), subject: widget.album.title);
          } else if (index == 1) {
            try {
              List<Asset> resultList =
                  await MultiImagePicker.pickImages(maxImages: 100);

              BuildContext dialogcontext;
              showDialog(
                  context: context,
                  builder: (context) {
                    dialogcontext = context;
                    return Dialog(
                      child: Container(
                          height: MediaQuery.of(context).size.height * .25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Padding(padding: EdgeInsets.all(5)),
                              Text('Uploading Images')
                            ],
                          )),
                    );
                  });

              for (Asset image in resultList) {
                final byteData = await image.getByteData();
                final file =
                    File('${(await getTemporaryDirectory()).path}/temp');
                await file.writeAsBytes(byteData.buffer.asUint8List(
                    byteData.offsetInBytes, byteData.lengthInBytes));
                await locator<AlbumService>()
                    .uploadImage(file, widget.album.albumId);
                await locator<AlbumManager>()
                    .getAlbumImages(widget.album.albumId);
              }

              Navigator.pop(dialogcontext);
            } on Exception catch (e) {
              print(e.toString());
            }
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Invite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_a_photo_rounded), label: 'Upload Images'),
          BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: widget.isSelectingImages
                  ? 'Download Images'
                  : 'Download Album'),
        ],
      );
    }
  }
}
