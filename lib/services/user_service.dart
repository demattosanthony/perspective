import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/models/User.dart';

abstract class UserService {
  Stream<UserAccount> getUserInfo();
  Future<UserAccount> getUserInfoList();
  Future<void> uploadProfileImg(String image);
  Future<String> deleteAccount();
  // Future<bool> updateUserInfo(String name, String username, String email);
}

class UserServiceImplementation implements UserService {
  @override
  Stream<UserAccount> getUserInfo() {
    String userId = FirebaseAuth.instance.currentUser.uid;
    var ref =
        FirebaseFirestore.instance.collection("users").doc(userId).snapshots();

    return ref.map((event) => UserAccount.fromSnap(event));
  }

  Future<UserAccount> getUserInfoList() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return UserAccount.fromJson(doc.data());
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

  Future<String> deleteAccount() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();
      await FirebaseAuth.instance.currentUser.delete();
    } catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed');
        return e.code;
      }
    }
    return 'success';
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
