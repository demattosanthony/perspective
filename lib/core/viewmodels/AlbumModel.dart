import 'dart:typed_data';

import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/Photo.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AlbumModel extends BaseModel {
  final AlbumService _albumService = locator<AlbumService>();

  // Future<List<Photo>> get photos => _albumService.photos;

  bool isSelectingImages = false;

  // void setSelectingImages() async {
  //   setState(ViewState.Busy);
  //   isSelectingImages = !isSelectingImages;
  //   if (isSelectingImages == false) {
  //     var photosList = await photos;
  //     for (var photo in photosList) {
  //       photo.isSelected = false;
  //     }
  //   }
  //   setState(ViewState.Idle);
  // }

  // void setImageSelected(int photoId) async {
  //   setState(ViewState.Busy);
  //   var photosList = await photos;
  //   for (var photo in photosList) {
  //     if (photo.photoId == photoId) {
  //       photo.isSelected = !photo.isSelected;
  //     }
  //   }
  //   setState(ViewState.Busy);
  // }

  // ignore: missing_return
  Future<bool> save(List<Photo> photosList) async {
    setState(ViewState.Busy);
    var client = http.Client();
    try {
      // var photosList = await photos;
      for (var photo in photosList) {
        //only download select photos
        if (isSelectingImages) {
          if (photo.isSelected) {
            var response = await http.get(photo.imageUrl);

            await ImageGallerySaver.saveImage(
                Uint8List.fromList(response.bodyBytes),
                quality: 60,
                name: photo.photoId.toString());
          }
        } else {
          //download entire album
          var response = await http.get(photo.imageUrl);

          await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.bodyBytes),
              quality: 60,
              name: photo.photoId.toString());
        }
      }
      // setSelectingImages();
      setState(ViewState.Busy);
      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
    }
  }
}
