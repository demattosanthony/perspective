import 'package:get_it/get_it.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/CameraViewModel.dart';
import 'package:point_of_view/core/viewmodels/create_event_model.dart';
import 'package:point_of_view/core/viewmodels/image_picker_model.dart';
import 'package:point_of_view/core/viewmodels/login_model.dart';
import 'package:point_of_view/core/viewmodels/profile_model.dart';
import 'package:point_of_view/core/viewmodels/register_model.dart';
import 'package:point_of_view/core/viewmodels/view_events_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());

  locator.registerFactory(() => ImagePickerModel());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => RegisterModel());
  locator.registerFactory(() => CreateEventModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => ViewEventsModel());
  locator.registerFactory(() => CameraViewModel());
}
