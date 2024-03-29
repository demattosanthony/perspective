import 'package:flutter/material.dart';
import 'package:point_of_view/app/album_pages/slideshow_page.dart';
import 'package:point_of_view/app/loading_page.dart';
import 'package:point_of_view/app/profile_pages/settings_page.dart';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/models/User.dart';
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
      case 'albumView':
        Album album = settings.arguments as Album;
        return MaterialPageRoute(
            builder: (_) => SelectedAlbumPage(album: album));
      case 'imageView':
        List args = settings.arguments as List;
        Photo photo = args[0];
        int albumId = args[1];
        List<Photo> photos = args[2];
        int index = args[3];
        return MaterialPageRoute(
            builder: (_) => ImageView(
                  albumId: albumId,
                  photo: photo,
                  photos: photos,
                  currentIndex: index,
                ));
      case 'profileView':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case 'createdAlbumsView':
        return MaterialPageRoute(builder: (_) => CreatedAlbumsPage());
      case 'joinedAlbumsView':
        return MaterialPageRoute(builder: (_) => JoinedAlbumsPage());
      case 'myAccountView':
        UserAccount data = settings.arguments as UserAccount;
        return MaterialPageRoute(
            builder: (_) => MyAccountPage(
                  userData: data,
                ));
      case 'settingsPage':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case 'loadingPage':
        String albumId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => LoadingPage(
                  albumId: albumId,
                ));
      case 'slideshow':
        Album album = settings.arguments as Album;
        return MaterialPageRoute(builder: (_) => SlideshowPage(album));
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
