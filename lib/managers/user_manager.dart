import 'package:image_picker/image_picker.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:rx_command/rx_command.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserManager {
  RxCommand<void, Stream> getUserInfo;
  Future<String> selectImage();
  RxCommand<String, void> updateProfileImg;
}

class UserManagerImplementation implements UserManager {
  @override
  RxCommand<void, Stream> getUserInfo;


  Future<String> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    return pickedFile.path;
  }

  UserManagerImplementation() {
    // getUserInfo = RxCommand.createAsyncNoParam(
    //     () => locator<UserService>().getUserInfo());

    updateProfileImg = RxCommand.createAsyncNoResult(
        (image) => locator<UserService>().uploadProfileImg(image));
  }

  @override
  RxCommand<String, void> updateProfileImg;
}
