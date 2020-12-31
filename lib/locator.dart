import 'package:get_it/get_it.dart';
import 'package:point_of_view/core/managers/album_manager.dart';
import 'package:point_of_view/core/managers/auth_manager.dart';
import 'package:point_of_view/core/managers/user_manager.dart';
import 'package:point_of_view/core/services/album_service.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/AdvCameraModel.dart';
import 'package:point_of_view/core/viewmodels/AlbumModel.dart';
import 'package:point_of_view/core/viewmodels/BottomNavBarModel.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'package:point_of_view/core/viewmodels/CreateAlbumModel.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/core/viewmodels/register_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //services
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton<UserService>(() => UserServiceImplementation());
  locator
      .registerLazySingleton<AlbumService>(() => AlbumServiceImplementation());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => CreateAlbumModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => CameraViewModel());
  locator.registerFactory(() => BottomNavBarModel());
  locator.registerFactory(() => AlbumModel());
  locator.registerFactory(() => AdvCameraModel());

  //managers
  locator
      .registerLazySingleton<AlbumManager>(() => AlbumManagerImplmenetation());
  locator.registerLazySingleton<AuthManager>(() => AuthManagerImplementation());
  locator.registerLazySingleton <
      UserManager>(() => UserManagerImplementation());
}
