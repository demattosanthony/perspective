import 'dart:io';

import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/services/ApiService.dart';
import 'package:rx_command/rx_command.dart';

abstract class CameraManager {
  RxCommand<Album, Album> selectedAlbum;
  RxCommand<String, void> uploadImage;
}

class CameraManagerImplementation implements CameraManager {
  @override
  RxCommand<Album, Album> selectedAlbum;

  @override
  RxCommand<String, void> uploadImage;

  CameraManagerImplementation() {
    selectedAlbum = RxCommand.createSync((album) => album);

    // uploadImage = RxCommand.createAsyncNoResult((param) => locator<ApiService>()
    //     .uploadImage(param, selectedAlbum.lastResult.title,
    //         selectedAlbum.lastResult.albumId));
  }

}
