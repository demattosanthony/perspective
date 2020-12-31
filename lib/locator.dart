import 'package:get_it/get_it.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/managers/auth_manager.dart';
import 'package:point_of_view/core/managers/camera_manager.dart';
import 'package:point_of_view/core/managers/user_manager.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //services
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton<UserService>(() => UserServiceImplementation());
  locator
      .registerLazySingleton<AlbumService>(() => AlbumServiceImplementation());

  locator.registerFactory(() => CameraViewModel());

  //managers
  locator
      .registerLazySingleton<AlbumManager>(() => AlbumManagerImplmenetation());
  locator.registerLazySingleton<AuthManager>(() => AuthManagerImplementation());
  locator.registerLazySingleton<UserManager>(() => UserManagerImplementation());
  locator.registerLazySingleton<CameraManager>(
      () => CameraManagerImplementation());
}
