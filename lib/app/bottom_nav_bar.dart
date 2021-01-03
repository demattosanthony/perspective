import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:point_of_view/app/profile_pages/profile_page.dart';
import 'dart:io' show Platform;
import 'album_pages/my_albums_page.dart';
import 'camera_pages/adv_camera_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> _pages;

  int _currentIndex = 0;

  Widget _currentPage;

  final PageStorageBucket _bucket = PageStorageBucket();

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[_currentIndex];
    });
  }

  void initPages() async {
    setState(() {
      _pages = [
        MyAlbumsPage(
          key: PageStorageKey('AlbumView'),
        ),
        AdvCameraPage(
          key: PageStorageKey('CameraView'),
        ),
        ProfilePage(key: PageStorageKey('ProfileView'))
      ];

      _currentIndex = 0;
      _currentPage = _pages[_currentIndex];
    });
  }

  @override
  void initState() {
    initPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: _bucket,
      child: Scaffold(
          body: _currentPage,
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.blueAccent,
            height: Platform.isAndroid
                ? MediaQuery.of(context).size.height * .10
                : 75,
            animationDuration: Duration(milliseconds: 250),
            index: _currentIndex,
            items: [
              Icon(Icons.home_rounded),
              Icon(Icons.camera_alt_rounded),
              Icon(Icons.person),
            ],
            onTap: (index) => changeTab(index),
          )),
    );
  }
}