import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/models/Photo.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/locator.dart';

class AlbumService {
  final ApiService _apiService = locator<ApiService>();

  Future<List<Album>> _myAlbums;
  Future<List<Album>> get myAlbums => _myAlbums;

  Future<List<Photo>> _photos;
  Future<List<Photo>> get photos => _photos;

  void getAlbums() {
    _myAlbums = _apiService.getAlbums();
  }

  Future<String> createAlbum(albumTitle) async {
    return _apiService.createAlbum(albumTitle);
  }

  void getPhotos(albumId) {
    _photos = _apiService.getPhotos(albumId);
  }

  void deleteAlbum(albumId) {
    _apiService.deleteAlbum(albumId);
  }

  void joinAlbum(sharedString) {
    _apiService.joinAlbum(sharedString);
  }
}
