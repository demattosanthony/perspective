import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel extends BaseModel {
  final UserInfoService _userInfoService = locator<UserInfoService>();

  Future<List<User>> get userInfo => _userInfoService.userInfo;

  void getUserInfo() async {
    setState(ViewState.Busy);
    //_user = await _cloudfirestoreService.getUserInfo();
    setState(ViewState.Idle);
  }

  void getImage() async {
    setState(ViewState.Busy);

    _userInfoService.getUserInfo();

    setState(ViewState.Idle);
  }

  void signOut() async {
    setState(ViewState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    setState(ViewState.Idle);
  }

  ProfileModel() {
    //getImage();
    //this.getUserInfo();
  }
}
