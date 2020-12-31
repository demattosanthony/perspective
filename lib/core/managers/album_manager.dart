import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/models/Photo.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:rx_command/rx_command.dart';

import '../../locator.dart';

abstract class AlbumManager {
  RxCommand<void, List<Album>> getAlbums;
  RxCommand<int, List<Photo>> getAlbumImages;
}

class AlbumManagerImplmenetation implements AlbumManager {
  @override
  RxCommand<void, List<Album>> getAlbums;

  @override
  RxCommand<int, List<Photo>> getAlbumImages;

  AlbumManagerImplmenetation() {
    getAlbums = RxCommand.createAsyncNoParam<List<Album>>(
        locator.get<AlbumService>().getAlbums);

    getAlbumImages = RxCommand.createAsync(
        (albumId) => locator<AlbumService>().getPhotos(albumId));

  }

}
