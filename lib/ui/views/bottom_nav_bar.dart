import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:point_of_view/ui/views/CameraView.dart';
import 'profile_view.dart';
import 'login_view.dart';
import 'MyAlbumsScreen.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isSignedIn = false;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final _pageController = PageController();
  final AuthService _authService = locator<AuthService>();

  List<Widget> _pages;
  int _currentIndex = 0;
  Widget _currentPage;

  void getLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isLoggedIn'));
    if (prefs.getBool('isLoggedIn') ?? false) {
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginState();

    _pages = [MyAlbumsScreen(), CameraView(), ProfileView()];
    _currentIndex = 0;
    _currentPage = _pages[_currentIndex];
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isSignedIn
        ? Scaffold(
            body: LoginView(),
          )
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body: _currentPage,
                bottomNavigationBar: CurvedNavigationBar(
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
