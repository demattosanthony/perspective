import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:point_of_view/constants.dart';
import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:point_of_view/widgets/ShowAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class AuthService {
  Future<bool> validateUsername(String username);
  Future<String> register(
      String username, String password, String email, String name, File image);
  Future<void> signOut();
  Future<void> login(String email, String password, BuildContext ctx);
}

class AuthServiceImplementation implements AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Function to fetch all usernames in database
  // returns true is username is already taken
  Future<bool> validateUsername(String username) async {
    var url = host + 'getUsernames';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (response.body.contains(username.toLowerCase()))
        return false;
      else
        return true;
    } else {
      throw Exception("Failed to get usernames");
    }
  }

  Future<int> getUserId(String username) async {
    var url = host + 'getUserId/${username.toLowerCase()}';
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse[0]['user_id'];
    } else {
      throw Exception('Could not get userId');
    }
  }

  // ignore: missing_return
  Future<String> register(String username, String password, String email,
      String name, File image) async {
    var url = host + 'addUser';
    bool usernameIsValid = await validateUsername(username);
    String profileImgUrl = '';

    if (usernameIsValid) {
      try {
        var user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (image != null)
          profileImgUrl = await locator<UserService>()
              .uploadProfileImg(locator<AuthManager>().getImage.lastResult);

        var response = await http.post(url, body: {
          'userId': user.user.uid,
          'username': username.toLowerCase(),
          'name': name,
          'email': email,
          'profileImgUrl': profileImgUrl
        });
        if (response.statusCode == 200) {
          return 'success';
        } else
          throw Exception('Failed adding User');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          return e.code;
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          return e.code;
        } else if (e.code == 'invalid-email') {
          return e.code;
        }
      } catch (e) {
        print(e);
        return e.code;
      }
    } else {
      return 'username-taken';
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showPlatformDialog(
          context: ctx,
          builder: (_) =>
              ShowAlert('Invalid Username or Password!', 'Try again.'));
      throw Exception(e.code);
    }
  }
}
