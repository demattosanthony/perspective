import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/locator.dart';

import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/models/User.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

abstract class AlbumService {
  Future<List<Album>> getAlbums();

  Future<List<Photo>> getPhotos(int albumId);
  Future<void> joinAlbum(String albumId);
  Future<void> createAlbum(String albumTitle);
  void deleteAlbum(int albumId, bool isOwner);
  Future<void> uploadImage(File image, int albumId);
  Future<void> deleteImage(int albumId, int imageId);
  Future<bool> isUserInAlbum(String albumId);
  Stream<List<UserAccount>> getAttendees(int albumId);
  Stream<List<UserAccount>> getUserData(List userIds);
}

class AlbumServiceImplementation implements AlbumService {
  // var host = "https://hidden-woodland-36838.herokuapp.com/";
  var host = 'http://localhost:3000/';

  @override
  Future<List<Album>> getAlbums() async {
    int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    var url = host + 'getUserAlbums/$userId';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Album> myAlbums =
          jsonResponse.map((data) => Album.fromJson(data)).toList();
      return myAlbums;
    } else {
      throw Exception('Could not fetch albums: ${response.statusCode}');
    }
  }

  @override
  Future<void> createAlbum(String albumTitle) async {
    var url = host + 'createAlbum';

    int userId = await locator<UserService>().getUserIdFromSharedPrefs();

    var response = await http
        .post(url, body: {'title': albumTitle, 'userid': userId.toString()});
    if (response.statusCode == 200) {
    } else {
      throw Exception('Could not create album');
    }
  }

  Future<void> uploadImage(File image, int albumId) async {
    String imageId = Uuid().v1();

    try {
      TaskSnapshot result = await FirebaseStorage.instance
          .ref('albumImages/$albumId/$imageId')
          .putFile(image);
      String downloadUrl = await result.ref.getDownloadURL();

      var url = host + 'uploadImageUrl';

      var response = await http.post(url,
          body: {'photourl': downloadUrl, 'albumid': albumId.toString()});
      print('testmg');
      if (response.statusCode != 200)
        throw Exception('Could not upload image url');
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  @override
  Future<List<Photo>> getPhotos(int albumId) async {
    var url = host + 'getImages/$albumId';

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Photo> photos = jsonResponse.map((data) => Photo.fromJson(data)).toList();
      print(photos[0].imageUrl);
      return photos;
    } else {
      throw Exception('Error fetching photos: ${response.statusCode}');
    }
  }

  @override
  void deleteAlbum(int albumId, bool isOwner) async {
    var url = host + "deleteAlbum";
    Map body = {"albumId": albumId.toString(), "isOwner": isOwner.toString()};
    var response = await http.post(url, body: body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete album');
    }
  }

  Future<bool> isUserInAlbum(String albumId) async {
    bool isUserInAlbum = false;
    String userId = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("albums")
        .doc(albumId)
        .get();
    Album album = Album.fromJson(data.data());

    if (album.attendeeIds.contains(userId) || album.ownerId == userId) {
      isUserInAlbum = true;
    }

    return isUserInAlbum;
  }

  @override
  Future<void> joinAlbum(String albumId) async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    bool userInAlbum = await isUserInAlbum(albumId);
    UserAccount userAccount = await locator<UserService>().getUserInfoList();

    if (!userInAlbum) {
      await FirebaseFirestore.instance
          .collection("albums")
          .doc(albumId)
          .update({
        "attendeeIds": [
          userId,
        ]
      });
      await FirebaseFirestore.instance
          .collection("albums")
          .doc(albumId)
          .collection("attendees")
          .add({
        'userId': userAccount.userId,
        'username': userAccount.username,
        'name': userAccount.name,
        'email': userAccount.email,
        'profileImgUrl': userAccount.profileImageUrl
      });
    }
  }

  Future<void> deleteImage(int albumId, int imageId) async {
    // await FirebaseFirestore.instance
    //     .collection("albums")
    //     .doc(albumId)
    //     .collection("photos")
    //     .doc(imageId)
    //     .delete();
  }

  Stream<List<UserAccount>> getAttendees(int albumId) {
    // var ref = FirebaseFirestore.instance
    //     .collection("albums")
    //     .doc(albumId)
    //     .collection("attendees")
    //     .snapshots();

    // return ref.map((list) {
    //   return list.docs.map((doc) => UserAccount.fromSnap(doc)).toList();
    // });
  }

  Stream<List<UserAccount>> getUserData(List userIds) {
    var ref = FirebaseFirestore.instance.collection("users").snapshots();

    return ref.map((list) {
      return list.docs.map((doc) => UserAccount.fromSnap(doc)).toList();
    });
  }
}
