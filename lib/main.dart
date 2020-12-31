import 'package:flutter/material.dart' hide Router;
import 'package:point_of_view/theme.dart';
import 'package:point_of_view/ui/views/Authentication/login_view.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/router.dart';
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
