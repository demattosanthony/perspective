import 'dart:io';

import 'package:point_of_view/constants.dart';
import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class AuthService {
  Future<bool> validateUsername(String username);
  Future<String> register(String username, String password, String email,
      String name, String imagePath);
  Future<void> signOut();
  Future<int> login(String username, String password);
}

class AuthServiceImplementation implements AuthService {
  // var host = 'http://localhost:3000/';
  // var host = "https://hidden-woodland-36838.herokuapp.com/";
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
      String name, String imagePath) async {
    var url = host + 'addUser';
    bool usernameIsValid = await validateUsername(username);
    String profileImgUrl = '';

    if (usernameIsValid) {
      print('valid username');
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (imagePath != null)
          profileImgUrl = await locator<UserService>()
              .uploadProfileImg(File(locator<AuthManager>().getImage.lastResult));

        var response = await http.post(url, body: {
          'username': username.toLowerCase(),
          'name': name,
          'email': email,
          'password': password,
          'profileImgUrl': profileImgUrl
        });
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', username);
          int userId = await getUserId(username);
          prefs.setInt('userId', userId);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    await auth.signOut();
  }

  Future<int> login(String username, String password) async {
    var client = http.Client();
    try {
      var url = host + 'login/${username.toLowerCase()}/$password';
      var response = await client.get(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.length == 0) return 400;
        // print(jsonResponse[0]['username']);
        String username = jsonResponse[0]['username'];
        int userId = jsonResponse[0]['user_id'];
        prefs.setString('username', username);
        prefs.setBool('isLoggedIn', true);
        prefs.setInt('userId', userId);
        return 200;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return 400;
      }
    } finally {
      client.close();
    }
  }
}
