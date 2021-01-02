import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class UserService {
  Stream<DocumentSnapshot> getUserInfo();
  Future<void> uploadProfileImg(String image);
  // Future<bool> updateUserInfo(String name, String username, String email);
}

class UserServiceImplementation implements UserService {
  

  @override
  Stream<DocumentSnapshot> getUserInfo() {
    String userId = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots();
  }

  @override
  Future<void> uploadProfileImg(String imagePath) async {
    File file = File(imagePath);
    String userId = FirebaseAuth.instance.currentUser.uid;

    try {
      TaskSnapshot result = await FirebaseStorage.instance
          .ref('user_profile_images/$userId/profile_img')
          .putFile(file);
      result.ref.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .update({"profileImgUrl": value})
          });
    } on FirebaseException catch (e) {
      print(e.code);
    }
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
