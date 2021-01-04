

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:point_of_view/app/theme.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'router.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();

  Widget _defautHome = new LoginView();

  // ignore: await_only_futures
  await FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      _defautHome = LoginView();
    } else {
      _defautHome = BottomNavBar();
    }
  });

  runApp(
    MaterialApp(
      theme: theme(),
      debugShowCheckedModeBanner: false,
      home: _defautHome,
      onGenerateRoute: Router.generateRoute,
    ),
  );
}