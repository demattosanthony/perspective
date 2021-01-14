import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:point_of_view/app/camera_pages/better_camera.dart';
import 'package:point_of_view/app/profile_pages/profile_page.dart';
import 'dart:io' show Platform;
import 'album_pages/my_albums_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> _pages;

  int _currentIndex = 0;


  final PageStorageBucket _bucket = PageStorageBucket();
  final _pageController = PageController();

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void initPages() async {
    setState(() {
      _pages = [
        MyAlbumsPage(
          key: PageStorageKey('AlbumView'),
        ),
        BetterCamera(
          // key: PageStorageKey('CameraView'),
        ),
        ProfilePage(key: PageStorageKey('ProfileView'))
      ];

      _currentIndex = 0;
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
          body: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                changeTab(index);
                _pageController.jumpToPage(index);
              });
            },
          ),
          bottomNavigationBar: SizedBox(
            height: 75,
                      child: CurvedNavigationBar(
              backgroundColor: Colors.blueAccent,
              
              animationDuration: Duration(milliseconds: 250),
              index: _currentIndex,
              items: [
                Icon(Icons.home_rounded),
                Icon(Icons.camera_alt_rounded),
                Icon(Icons.person),
              ],
              onTap: (index) {
                setState(() {
                  changeTab(index);
                  _pageController.jumpToPage(index);
                });
              },
            ),
          )),
    );
  }
}
