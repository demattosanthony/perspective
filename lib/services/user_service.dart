import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/constants.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class UserService {
  Future<UserAccount> getUserInfo();
  Future<String> uploadProfileImg(String image);
  Future<String> deleteAccount();
  Future<int> getUserIdFromSharedPrefs();
  // Future<bool> updateUserInfo(String name, String username, String email);
}

class UserServiceImplementation implements UserService {
  // var host = 'http://localhost:3000/';
  // var host = "https://hidden-woodland-36838.herokuapp.com/";
  @override
  Future<UserAccount> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId');

    var url = host + 'getUserInfo/$userId';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      List<UserAccount> userInfo =
          jsonResponse.map((data) => UserAccount.fromJson(data)).toList();
      // print(userInfo[0].userId);
      return userInfo[0];
    } else {
      throw Exception('Faield to fetch user info');
    }
  }

  @override
  Future<String> uploadProfileImg(String imagePath) async {
    File file = File(imagePath);
    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    String photoUrl = '';
    try {
      TaskSnapshot result = await FirebaseStorage.instance
          .ref('user_profile_images/${userId.toString()}/profile_img')
          .putFile(file);
      photoUrl = await result.ref.getDownloadURL();
      var url = host + 'updateProfileImg';
      var response = await http.put(url,
          body: {'profileImageUrl': photoUrl, 'userId': userId.toString()});
      locator<UserManager>().getUserInfo();
      if (response.statusCode != 200) {
        throw Exception('Could not upload profile img');
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
    return photoUrl;
  }

  Future<String> deleteAccount() async {
    try {
      int userId = await locator<UserService>().getUserIdFromSharedPrefs();
      var url = host + 'deleteAccount/${userId.toString()}';
      var response = await http.delete(url);
      if (response.statusCode != 200)
        throw Exception('Could not delete user');
      else {
        await FirebaseAuth.instance.currentUser.delete();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', false);

        return 'sucess';
      }
    } catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed');
        return e.code;
      }
    }
    return 'success';
  }

  @override
  Future<int> getUserIdFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // @override
  // Future<bool> updateUserInfo(
  //     String name, String username, String email) async {
  //   int userId = await locator<UserService>().getUserIdFromSharedPrefs();
  //   User _userInfo = await getUserInfo();
  //   var url = host + 'updateUserInfo';
  //   Map body = {
  //     'name': name == '' ? _userInfo.name : name,
  //     'userId': userId.toString(),
  //     'username': username == '' ? _userInfo.username : username,
  //     'email': email == '' ? _userInfo.email : email
  //   };
  //   var response = await http.put(url, body: body);
  //   return response.statusCode == 200;
  // }
}
