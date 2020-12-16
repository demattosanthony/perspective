import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Event.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/views/CameraView.dart';
import 'package:point_of_view/ui/views/register_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case 'camera':
        return MaterialPageRoute(builder: (_) => CameraView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
