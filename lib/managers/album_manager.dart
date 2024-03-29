import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:rx_command/rx_command.dart';

abstract class AlbumManager {
  late RxCommand<void, List<Album>> getAlbums;
  late RxCommand<int, List<Photo>> getAlbumImages;
  late RxCommand<int, List<UserAccount>> getAttendees;
  void addToSelectedPhotos(Photo photo);
  void deleteFromSelectedPhotos(Photo photo);
  List<Photo> getSelectedImages();
  late RxCommand<int, void> joinAlbum;
}

class AlbumManagerImplmenetation implements AlbumManager {
  List<Photo> _selectedPhotos = [];

  void addToSelectedPhotos(Photo photo) {
    if (_selectedPhotos
        .where((element) => element.imageId == photo.imageId)
        .isEmpty) {
      _selectedPhotos.add(photo);
    } else {
      print('already in list');
    }
    print(_selectedPhotos);
  }

  void deleteFromSelectedPhotos(Photo photo) {
    _selectedPhotos.removeWhere((element) => element.imageId == photo.imageId);
  }

  List<Photo> getSelectedImages() {
    return _selectedPhotos;
  }

  AlbumManagerImplmenetation() {
    joinAlbum = RxCommand.createAsyncNoResult(
        (albumId) => locator<AlbumService>().joinAlbum(albumId));

    getAlbums = RxCommand.createAsyncNoParam<List<Album>>(
        locator.get<AlbumService>().getAlbums);

    getAlbumImages = RxCommand.createAsync(
        (albumId) => locator<AlbumService>().getPhotos(albumId));

    getAttendees = RxCommand.createAsync(
        (albumId) => locator<AlbumService>().getAttendees(albumId));
  }

  @override
  late RxCommand<int, void> joinAlbum;

  @override
  late RxCommand<void, List<Album>> getAlbums;

  @override
  late RxCommand<int, List<Photo>> getAlbumImages;

  @override
  late RxCommand<int, List<UserAccount>> getAttendees;
}
