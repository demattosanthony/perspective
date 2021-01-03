import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  int userId;
  String name;
  String username;
  String email;
  String profileImageUrl;

  UserAccount(
      {this.userId,
      this.username,
      this.name,
      this.email,
      this.profileImageUrl});

  // User.fromJson(Map<String, dynamic> parsedJSON)
  //     : userId = parsedJSON['user_id'],
  //       username = parsedJSON['username'],
  //       name = parsedJSON['name'],
  //       email = parsedJSON['email'],
  //       profileImageUrl = parsedJSON['profile_img_url'];

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
        userId: json['user_id'],
        name: json['name'],
        username: json['username'],
        email: json['email'],
        profileImageUrl: json['profile_img_url']);
  }

  factory UserAccount.fromSnap(DocumentSnapshot doc) {
    var data = doc.data();
    return UserAccount(
        userId: data['userId'],
        name: data['name'],
        username: data['username'],
        email: data['email'],
        profileImageUrl: data['profileImgUrl']);
  }
}
