import 'package:flutter/material.dart';
import 'package:point_of_view/app/loading_page.dart';
import 'package:point_of_view/app/profile_pages/settings_page.dart';
import 'package:point_of_view/widgets/ImageView.dart';
import 'package:point_of_view/app/album_pages/selected_album_page.dart';
import 'package:point_of_view/app/login_pages/login_view.dart';
import 'package:point_of_view/app/login_pages/register_view.dart';
import 'package:point_of_view/app/profile_pages/created_albums_page.dart';
import 'package:point_of_view/app/profile_pages/joined_albums_page.dart';
import 'package:point_of_view/app/profile_pages/profile_page.dart';
import 'package:point_of_view/app/bottom_nav_bar.dart';
import 'package:point_of_view/app/profile_pages/my_account_page.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case 'loginView':
        return MaterialPageRoute(builder: (_) => LoginView());
      case 'register':
        return MaterialPageRoute(builder: (_) => RegisterView());
      // case 'camera':
      //   return MaterialPageRoute(builder: (_) => CameraView());
      case 'albumView':
        var album = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SelectedAlbumPage(album: album));
      case 'imageView':
        List args = settings.arguments;
        var photo = args[0];
        var albumId = args[1];
        return MaterialPageRoute(
            builder: (_) => ImageView(
                  albumId: albumId,
                  photo: photo,
                ));
      case 'profileView':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case 'createdAlbumsView':
        return MaterialPageRoute(builder: (_) => CreatedAlbumsPage());
      case 'joinedAlbumsView':
        return MaterialPageRoute(builder: (_) => JoinedAlbumsPage());
      case 'myAccountView':
        var data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => MyAccountPage(
                  userData: data,
                ));
      case 'settingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case 'loadingPage':
        var albumId = settings.arguments;
        return MaterialPageRoute(builder: (_) => LoadingPage(albumId: albumId,));
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
