import 'package:point_of_view/core/enums/viewstate.dart';
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

  List<Album> get myAlbums => _apiService.myAlbums;
  String get profileImgUrl => _userInfoService.profileImgUrl;

  Future<List<Album>> getAlbums() async {
    setState(ViewState.Busy);
    await _apiService.getAlbums();
    setState(ViewState.Idle);
  }

  MyAlbumsModel() {
    print('ININTING');
    if (myAlbums == null) getAlbums();
  }
}
