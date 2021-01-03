import 'package:get_it/get_it.dart';
import 'package:point_of_view/managers/album_manager.dart';
import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/managers/camera_manager.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/services/album_service.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/services/auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //services
  locator.registerLazySingleton<AuthService>(() => AuthServiceImplementation());
  locator.registerLazySingleton<UserService>(() => UserServiceImplementation());
  locator
      .registerLazySingleton<AlbumService>(() => AlbumServiceImplementation());

  //managers
  locator
      .registerLazySingleton<AlbumManager>(() => AlbumManagerImplmenetation());
  locator.registerLazySingleton<AuthManager>(() => AuthManagerImplementation());
  locator.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  locator.registerLazySingleton<CameraManager>(
      () => CameraManagerImplementation());
}
