import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/locator.dart';

class UserInfoService {
  final ApiService _apiService = locator<ApiService>();

  Future<List<User>> _userInfo;
  Future<List<User>> get userInfo => _userInfo;

  void getUserInfo() async {
    _userInfo = _apiService.getUserInfo();
  }
}
