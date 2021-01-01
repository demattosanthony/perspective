import 'dart:io';

import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class UserService {
  Future<int> getUserIdFromSharedPrefs();
  Future<User> getUserInfo();
  void changeProfileImage(String image);
  Future<bool> updateUserInfo(String name, String username, String email);
}

class UserServiceImplementation implements UserService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";
  ApiService _apiService = locator<ApiService>();

  @override
  Future<int> getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  @override
  Future<User> getUserInfo() async {
    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    var url = host + 'getUserInfo/$userId';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<User> userInfo =
          (jsonResponse as List).map((data) => User.fromJson(data)).toList();
      return userInfo[0];
    } else {
      throw Exception('Failed to fetch User Info');
    }
  }

  @override
  void changeProfileImage(String image) async {
    var client = http.Client();
    try {
      int userId = await locator<UserService>().getUserIdFromSharedPrefs();

      String profileImageUrl =
          await _apiService.uploadImage(File(image), "profileImage", 0);

      var url = host + 'updateProfileImg';
      Map body = {
        'profileImageUrl': profileImageUrl,
        'userId': userId.toString()
      };
      var response = await http.put(url, body: body);
      if (response.statusCode == 200)
        print('Success');
      else {}
    } finally {
      client.close();
    }
  }

  @override
  Future<bool> updateUserInfo(
      String name, String username, String email) async {
    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    User _userInfo = await getUserInfo();
    var url = host + 'updateUserInfo';
    Map body = {
      'name': name == '' ? _userInfo.name : name,
      'userId': userId.toString(),
      'username': username == '' ? _userInfo.username : username,
      'email': email == '' ? _userInfo.email : email
    };
    var response = await http.put(url, body: body);
    return response.statusCode == 200;
  }
}
