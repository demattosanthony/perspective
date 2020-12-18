import 'package:point_of_view/core/models/Album.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/locator.dart';

class AlbumService {
  final ApiService _apiService = locator<ApiService>();

  String _shareString;

  Future<List<Album>> _myAlbums;
  Future<List<Album>> get myAlbums => _myAlbums;

  void getAlbums() {
    _myAlbums = _apiService.getAlbums();
  }
}
