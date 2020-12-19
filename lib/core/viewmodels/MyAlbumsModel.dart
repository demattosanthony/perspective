import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import '../models/Album.dart';

class MyAlbumsModel extends BaseModel {
  ApiService _apiService = locator<ApiService>();
  UserInfoService _userInfoService = locator<UserInfoService>();
  AlbumService _albumService = locator<AlbumService>();

  Future<List<Album>> get myAlbums => _albumService.myAlbums;
  Future<List<User>> get userInfo => _userInfoService.userInfo;

  void getAlbums() async {
    setState(ViewState.Busy);
    _albumService.getAlbums();
    setState(ViewState.Idle);
  }

  

  void getPhotos(albumId) {
    setState(ViewState.Busy);
    _albumService.getPhotos(albumId);
    setState(ViewState.Idle);
  }

  void deleteAlbum(albumId) {
    setState(ViewState.Busy);
    _apiService.deleteAlbum(albumId);
    setState(ViewState.Idle);
  }

  MyAlbumsModel() {
    print('ININTING');
    if (myAlbums == null) getAlbums();
  }
}
