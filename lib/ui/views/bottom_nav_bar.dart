import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:point_of_view/core/viewmodels/BottomNavBarModel.dart';
import 'login_view.dart';

import 'base_view.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BottomNavBarModel>(
        builder: (context, model, child) => !model.isSignedIn
            ? Scaffold(
                body: LoginView(),
              )
            : WillPopScope(
                onWillPop: () async => false,
                child: PageStorage(
                  bucket: model.bucket,
                  child: Scaffold(
                      body: model.currentPage,
                      bottomNavigationBar: CurvedNavigationBar(
                        animationDuration: Duration(milliseconds: 250),
                        index: model.currentIndex,
                        items: [
                          Icon(Icons.home_rounded),
                          Icon(Icons.camera_alt_rounded),
                          Icon(Icons.person),
                        ],
                        onTap: (index) => model.changeTab(index),
                      )),
                ),
              ));
  }
}
