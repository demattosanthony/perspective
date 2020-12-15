import 'package:flutter/material.dart';
import 'package:point_of_view/core/models/Event.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/views/camera_view.dart';
import 'package:point_of_view/ui/views/create_event_views/image_picker_view.dart';
import 'package:point_of_view/ui/views/create_event_views/share_event_view.dart';
import 'package:point_of_view/ui/views/register_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar(0));
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case 'image-picker':
        return MaterialPageRoute(builder: (_) => ImagePickerView());
      case 'share-event':
        var event = settings.arguments as Event;
        return MaterialPageRoute(builder: (_) => ShareEventView(event));
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
