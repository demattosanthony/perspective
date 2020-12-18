import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Album.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:point_of_view/ui/views/CameraView.dart';
import 'package:point_of_view/ui/views/MyAlbumsView.dart';
import 'package:point_of_view/ui/views/profile_view.dart';

class BottomNavBarModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final UserInfoService _userInfoService = locator<UserInfoService>();
  final AlbumService _albumService = locator<AlbumService>();

  bool _isSignedIn = false;
  List<Widget> _pages;
  int _currentIndex = 0;
  Widget _currentPage;
  final PageStorageBucket _bucket = PageStorageBucket();

  bool get isSignedIn => _isSignedIn;
  List<Widget> get pages => _pages;
  int get currentIndex => _currentIndex;
  Widget get currentPage => _currentPage;
  PageStorageBucket get bucket => _bucket;

  void getLoginState() async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
    if (prefs.getBool('isLoggedIn') ?? false) {
      _isSignedIn = true;
    } else {
      _isSignedIn = false;
    }
    setState(ViewState.Idle);
  }

  void initPages() async {
    setState(ViewState.Busy);
    _pages = [
      MyAlbumsView(
        key: PageStorageKey('AlbumView'),
      ),
      CameraView(
        key: PageStorageKey('CameraView'),
      ),
      ProfileView(key: PageStorageKey('ProfileView'))
    ];
    _currentIndex = 0;
    _currentPage = _pages[_currentIndex];
    setState(ViewState.Idle);
  }

  void changeTab(int index) {
    setState(ViewState.Busy);
    _currentIndex = index;
    _currentPage = _pages[_currentIndex];
    setState(ViewState.Idle);
  }

  BottomNavBarModel() {
    getLoginState();
    _userInfoService.getUserInfo();
    _albumService.getAlbums();
    initPages();
  }
}
