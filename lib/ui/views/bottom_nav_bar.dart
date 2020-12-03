import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'profile_view.dart';
import 'login_view.dart';
import 'create_event_views/create_event_view.dart';
import 'events_screen.dart';
import 'package:page_transition/page_transition.dart';


class BottomNavBar extends StatefulWidget {
  int page;

  BottomNavBar(this.page);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  bool isSignedIn = false;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final _pageController = PageController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //FirebaseAuth.instance.authStateChanges().listen((useraccount) {
  //     if (useraccount != null) {
  //       setState(() {
  //         isSignedIn = true;
  //       });
  //     } else {
  //       setState(() {
  //         isSignedIn = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _page = widget.page;

    return !isSignedIn
        ? Scaffold(
            body: LoginView(),
          )
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body: PageView(
                  physics:new NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    EventsScreen(),
                    ProfileView(),
                    CreateEventView(),
                    ProfileView()
                  ],
                  onPageChanged: (int index) {
                    setState(() {
                      _pageController.jumpToPage(index);
                    });
                  },
                ),
                bottomNavigationBar: CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  animationDuration: Duration(milliseconds: 250),
                  index: _page,
                  items: [
                    Icon(Icons.home_rounded),
                    Icon(Icons.camera_alt_rounded),
                    Icon(Icons.add),
                    Icon(Icons.person),
                  ],
                  onTap: (index) {
                    setState(() {
                      if (index == 2)
                        Navigator.push(
                            context,
                            PageTransition(
                                child: CreateEventView(),
                                type: PageTransitionType.rightToLeftWithFade));
                      else
                        _pageController.jumpToPage(index);
                    });
                  },
                )),
          );
  }
}
