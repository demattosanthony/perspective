import 'package:get_it/get_it.dart';
import 'package:point_of_view/core/services/AlbumService.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/BottomNavBarModel.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'package:point_of_view/core/viewmodels/CreateAlbumModel.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/core/viewmodels/register_model.dart';
import 'package:point_of_view/core/viewmodels/MyAlbumsModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserInfoService());
  locator.registerLazySingleton(() => AlbumService());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => CreateAlbumModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => MyAlbumsModel());
  locator.registerFactory(() => CameraViewModel());
  locator.registerFactory(() => BottomNavBarModel());
}
