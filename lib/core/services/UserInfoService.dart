import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/locator.dart';

class UserInfoService {
  final ApiService _apiService = locator<ApiService>();
  final AuthService _authService = locator<AuthService>();

  Future<List<User>> _userInfo;
  Future<List<User>> get userInfo => _userInfo;

  void getUserInfo() async {
    _userInfo = _apiService.getUserInfo();
  }

  void updateProfileImage(int userId, String image) async {
    _authService.changeProfileImage(userId, image);
  }
}
