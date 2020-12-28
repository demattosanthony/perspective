import 'package:flutter/material.dart';
import 'package:point_of_view/ui/views/Albums/ImageView.dart';
import 'package:point_of_view/ui/views/Albums/AlbumView.dart';
import 'package:point_of_view/ui/views/Camera/CameraView.dart';
import 'package:point_of_view/ui/views/Authentication/register_view.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case 'camera':
        return MaterialPageRoute(builder: (_) => CameraView());
      case 'albumView':
        var albumid = settings.arguments;
        return MaterialPageRoute(builder: (_) => AlbumView(albumid));
      case 'imageView':
        var imageUrl = settings.arguments;
        return MaterialPageRoute(builder: (_) => ImageView(imageUrl));
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
