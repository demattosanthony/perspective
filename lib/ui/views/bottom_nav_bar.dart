
import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:point_of_view/core/viewmodels/BottomNavBarModel.dart';
import 'dart:io' show Platform;
import 'base_view.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BottomNavBarModel>(
        builder: (context, model, child) => WillPopScope(
                onWillPop: () async => false,
                child: PageStorage(
                  bucket: model.bucket,
                  child: Scaffold(
                      body: model.currentPage,
                      bottomNavigationBar: CurvedNavigationBar(
                        backgroundColor: Colors.blue,
                        height: Platform.isAndroid ? MediaQuery.of(context).size.height*.10 : 75,
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
