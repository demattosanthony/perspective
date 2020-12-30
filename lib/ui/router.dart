import 'package:flutter/material.dart';
import 'package:point_of_view/ui/components/ImageView.dart';
import 'package:point_of_view/ui/views/Albums/Selected%20Album/AlbumView.dart';
import 'package:point_of_view/ui/views/Authentication/login_view.dart';
import 'package:point_of_view/ui/views/Camera/CameraView.dart';
import 'package:point_of_view/ui/views/Authentication/register_view.dart';
import 'package:point_of_view/ui/views/Created%20&%20Joined%20Albums/created_albums_view.dart';
import 'package:point_of_view/ui/views/Created%20&%20Joined%20Albums/joined_albums_view.dart';
import 'package:point_of_view/ui/views/Profile/profile_view.dart';
import 'package:point_of_view/ui/views/bottom_nav_bar.dart';
import 'package:point_of_view/ui/views/my_account/my_account_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case 'loginView':
        return MaterialPageRoute(builder: (_) => LoginView());
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      case 'camera':
        return MaterialPageRoute(builder: (_) => CameraView());
      case 'albumView':
        var album = settings.arguments;
        return MaterialPageRoute(builder: (_) => AlbumView(album: album));
      case 'imageView':
        var imageUrl = settings.arguments;
        return MaterialPageRoute(builder: (_) => ImageView(imageUrl));
      case 'profileView':
        return MaterialPageRoute(builder: (_) => ProfileView());
      case 'createdAlbumsView':
        return MaterialPageRoute(builder: (_) => CreatedAlbumsView());
      case 'joinedAlbumsView':
        return MaterialPageRoute(builder: (_) => JoinedAlbumsView());
      case 'myAccountView':
        var data = settings.arguments;
        return MaterialPageRoute(builder: (_) => MyAccountView(userData: data,));
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
