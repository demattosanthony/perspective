import 'package:image_picker/image_picker.dart';
import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:rx_command/rx_command.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserManager {
  RxCommand<void, User> getUserInfo;
  void signOut();
  Future<String> selectImage();
}

class UserManagerImplementation implements UserManager {
  @override
  RxCommand<void, User> getUserInfo;

  void signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  Future<String> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    return pickedFile.path;
  }

  UserManagerImplementation() {
    getUserInfo = RxCommand.createAsyncNoParam(
        () => locator<UserService>().getUserInfo());
  }
}
