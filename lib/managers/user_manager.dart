import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:rx_command/rx_command.dart';

abstract class UserManager {
  late RxCommand<void, UserAccount> getUserInfo;
  Future<String> selectImage();
  late RxCommand<File, void> updateProfileImg;
}

class UserManagerImplementation implements UserManager {
  Future<String> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    return pickedFile!.path;
  }

  UserManagerImplementation() {
    updateProfileImg = RxCommand.createAsyncNoResult(
        (image) => locator<UserService>().uploadProfileImg(image));

    getUserInfo = RxCommand.createAsyncNoParam(
        () => locator<UserService>().getUserInfo());
  }

  @override
  late RxCommand<File, void> updateProfileImg;

  @override
  late RxCommand<void, UserAccount> getUserInfo;
}
