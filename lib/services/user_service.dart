import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/constants.dart';
import 'package:point_of_view/locator.dart';
import 'package:point_of_view/managers/user_manager.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class UserService {
  Future<UserAccount> getUserInfo();
  Future<String> uploadProfileImg(File image);
  Future<String> deleteAccount();
  Future<int> getUserIdFromSharedPrefs();
  Future<String> updateUserInfo(String name, String username, String email);
}

class UserServiceImplementation implements UserService {

  @override
  Future<UserAccount> getUserInfo() async {

    String userId = FirebaseAuth.instance.currentUser!.uid;

    var url = host + 'getUserInfo/$userId';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<UserAccount> userInfo =
          jsonResponse.map((data) => UserAccount.fromJson(data)).toList();
      return userInfo[0];
    } else {
      throw Exception('Faield to fetch user info');
    }
  }

  @override
  Future<String> uploadProfileImg(File img) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    String photoUrl = '';
    try {
      TaskSnapshot result = await FirebaseStorage.instance
          .ref('user_profile_images/${userId.toString()}/profile_img')
          .putFile(img);
      photoUrl = await result.ref.getDownloadURL();
      var url = host + 'updateProfileImg';
      var response = await http
          .put(Uri.parse(url), body: {'profileImageUrl': photoUrl, 'userId': userId});
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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      var url = host + 'deleteAccount/$userId';
      var response = await http.delete(Uri.parse(url));
      if (response.statusCode != 200)
        throw Exception('Could not delete user');
      else {
        await FirebaseAuth.instance.currentUser!.delete();
        return 'sucess';
      }
    } on FirebaseAuthException catch (e) {
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
    return prefs.getInt('userId')!;
  }

  @override
  Future<String> updateUserInfo(
      String name, String username, String email) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    UserAccount _userInfo = await getUserInfo();

    if (username != '') {
      bool isUsernameTaken =
          await locator<AuthService>().validateUsername(username);
      if (isUsernameTaken) {
        return 'username-taken';
      }
    }
    var url = host + 'updateUserInfo';
    Map body = {
      'name': name == '' ? _userInfo.name : name,
      'userId': userId,
      'username': username == '' ? _userInfo.username : username,
      'email': email == '' ? _userInfo.email : email
    };
    var response = await http.put(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return 'failed';
    }
  }
}
