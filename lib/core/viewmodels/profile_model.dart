import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/user_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileModel extends BaseModel {







  Future<String> selectImage() async {
    setState(ViewState.Busy);
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(ViewState.Idle);
    return pickedFile.path;
  }

  void signOut() async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    setState(ViewState.Idle);
  }

  ProfileModel() {

  }
}
