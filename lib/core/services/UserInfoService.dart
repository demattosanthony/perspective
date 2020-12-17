import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/locator.dart';

class UserInfoService {
  final ApiService _apiService = locator<ApiService>();

  String _profileImgUrl;
  String _username;
  String _name;

  String get profileImgUrl => _profileImgUrl;
  String get username => _username;
  String get name => _name;

  void getUserInfo() async {
    List<User> userInfo = await _apiService.getUserInfo();
    for (var user in userInfo) {
      _profileImgUrl = user.profileImageUrl;
      print(_profileImgUrl);
      _username = user.username;
      print(_username);
      _name = user.name;
    }
  }
}
