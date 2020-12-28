import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/ui/views/Camera/AdvancedCameraView.dart';
import 'package:point_of_view/ui/views/Albums/MyAlbumsView.dart';
import 'package:point_of_view/ui/views/Profile/profile_view.dart';

class BottomNavBarModel extends BaseModel {

  List<Widget> _pages;
  int _currentIndex = 0;
  Widget _currentPage;
  final PageStorageBucket _bucket = PageStorageBucket();

  List<Widget> get pages => _pages;
  int get currentIndex => _currentIndex;
  Widget get currentPage => _currentPage;
  PageStorageBucket get bucket => _bucket;


  void initPages() async {
    setState(ViewState.Busy);
    _pages = [
      MyAlbumsView(
        key: PageStorageKey('AlbumView'),
      ),
      AdvCameraView(
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
    initPages();
  }
}
