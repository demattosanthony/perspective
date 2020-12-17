import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/UserInfoService.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/core/viewmodels/base_model.dart';
import '../../locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final ApiService _apiService = locator<ApiService>();
  final UserInfoService _userInfoService = locator<UserInfoService>();

  String get profileImage => _userInfoService.profileImgUrl;
  String get username => _userInfoService.username;
  String get name => _userInfoService.name;

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
