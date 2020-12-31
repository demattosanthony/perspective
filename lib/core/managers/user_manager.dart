import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:rx_command/rx_command.dart';

abstract class UserManager {
  RxCommand<void, User> getUserInfo;
}

class UserManagerImplementation implements UserManager {
  @override
  RxCommand<void, User> getUserInfo;

  UserManagerImplementation() {
    getUserInfo = RxCommand.createAsyncNoParam(
        () => locator<UserService>().getUserInfo());
  }
}
