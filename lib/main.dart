import 'package:flutter/material.dart' hide Router;
import 'package:point_of_view/app/theme.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router.dart';
import 'locator.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  Widget _defautHome = new LoginView();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) _defautHome = BottomNavBar();

  runApp(
    MaterialApp(
      theme: theme(),
      debugShowCheckedModeBanner: false,
      home: _defautHome,
      onGenerateRoute: Router.generateRoute,
    ),
  );
}
