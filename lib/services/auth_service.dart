import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/services/ApiService.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final ApiService _apiService = locator<ApiService>();
  var host = "https://hidden-woodland-36838.herokuapp.com/";
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> validateUsername(String username) async {
    bool isValid = true;
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (username == doc['username']) {
                  isValid = false;
                }
              })
            });

    if (isValid)
      return true;
    else
      return false;
  }

  // ignore: missing_return
  Future<String> register(String username, String password, String email,
      String name, String imagePath) async {
    bool usernameIsValid = await validateUsername(username);

    if (usernameIsValid) {
      print('valid username');
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((currentUser) => FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.user.uid)
                    .set({
                  "uid": currentUser.user.uid,
                  "name": name,
                  "username": username,
                  "email": email,
                  "password": password,
                  "profileImgUrl": ""
                }));
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

      locator<UserService>().uploadProfileImg(locator<AuthManager>().getImage.lastResult);

    } else {
      return 'username-taken';
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  void changeProfileImage(int userId, String image) async {
    var client = http.Client();
    try {
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

  Future<String> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return e.code;
      } else if (e.code == 'invalid-email') {
        return e.code;
      }
    }

    return 'success';
  }

}
