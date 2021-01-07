import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class SelectedAlbumBottomNavBar extends StatelessWidget {
  const SelectedAlbumBottomNavBar(
      {Key key,
      @required this.widget,
      @required this.isSelectingImages,
      @required this.album,
      @required this.photos})
      : super(key: key);

  final SelectedAlbumPage widget;
  final bool isSelectingImages;
  final Album album;
  final List<Photo> photos;

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
          if (!isSelectingImages) {
            // Download entire album
            var photos =
               locator<AlbumManager>().getAlbumImages.lastResult;
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
          } else {
            // download selected images
            List<Photo> _photos = locator<AlbumManager>().getSelectedImages();
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
                  builder: (_) => ShowAlert("Download Complete!", "Success"));
            } catch (e) {
              throw Exception('Could no download album');
            }
          }
        } else if (index == 0) {
          Uri shareUrl = await locator<DynamicLinkService>()
              .createDynamicLink(album.albumId.toString(), album.title);
          Share.share(shareUrl.toString(), subject: album.title);
        } else if (index == 1) {
          try {
            List<Asset> resultList =
                await MultiImagePicker.pickImages(maxImages: 100);
            for (Asset image in resultList) {
              final byteData = await image.getByteData();
              final file = File('${(await getTemporaryDirectory()).path}/temp');
              await file.writeAsBytes(byteData.buffer
                  .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
              await locator<AlbumService>().uploadImage(file, album.albumId);
            }
          } on Exception catch (e) {
            print(e.toString());
          }
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