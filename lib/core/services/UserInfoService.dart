import 'package:point_of_view/core/models/User.dart';
import 'package:point_of_view/core/services/ApiService.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;

class UserInfoService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";

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

  void updateUserInfo(
      int userId, String name, String username, String email) async {
    List<User> _userInfo = await userInfo;
    var url = host + 'updateUserInfo';
    Map body = {
      'name': name == '' ? _userInfo[0].name : name,
      'userId': userId.toString(),
      'username': username == '' ? _userInfo[0].username : username,
      'email': email == '' ? _userInfo[0].email : email
    };
    var response = await http.put(url, body: body);
    print(response.statusCode);
  }
}
