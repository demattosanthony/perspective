import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import '../models/Album.dart';

class MyAlbumsModel extends BaseModel {
  ApiService _apiService = locator<ApiService>();

  List<Album> _myAlbums = [];
  List<Album> get myAlbums => _myAlbums;

  void getEvents() async {
    setState(ViewState.Busy);
    _myAlbums = await _apiService.getAlbums();
    setState(ViewState.Idle);
  }

  MyAlbumsModel() {
    print('ININTING');
    getEvents();
  }
}
