import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/constants.dart';

import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/models/User.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

abstract class AlbumService {
  Future<List<Album>> getAlbums();

  Future<List<Photo>> getPhotos(int albumId);
  Future<int> joinAlbum(int albumId);
  Future<void> createAlbum(String albumTitle);
  void deleteAlbum(int albumId, bool isOwner);
  Future<void> uploadImage(File image, int albumId);
  Future<void> deleteImage(int albumId, int imageId);
  Future<List<UserAccount>> getAttendees(int albumId);
}

class AlbumServiceImplementation implements AlbumService {
  @override
  Future<List<Album>> getAlbums() async {
    // int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    String userId = FirebaseAuth.instance.currentUser.uid;
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

    // int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    String userId = FirebaseAuth.instance.currentUser.uid;

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
      // int userId = await locator<UserService>().getUserIdFromSharedPrefs();
      String userId = FirebaseAuth.instance.currentUser.uid;

      var response = await http.post(url, body: {
        'photourl': downloadUrl,
        'albumid': albumId.toString(),
        'userId': userId
      });
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
      List<Photo> photos =
          jsonResponse.map((data) => Photo.fromJson(data)).toList();
      return photos;
    } else {
      throw Exception('Error fetching photos: ${response.statusCode}');
    }
  }

  @override
  void deleteAlbum(int albumId, bool isOwner) async {
    var url = host + "deleteAlbum";
    Map body = {
      "albumId": albumId.toString(),
      "isOwner": isOwner.toString(),
      "userId": FirebaseAuth.instance.currentUser.uid
    };
    var response = await http.post(url, body: body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete album');
    }
  }

  @override
  Future<int> joinAlbum(int albumId) async {
    // int userId = await locator<UserService>().getUserIdFromSharedPrefs();
    String userId = FirebaseAuth.instance.currentUser.uid;
    var url = host + 'joinAlbum';
    var response = await http
        .post(url, body: {'albumId': albumId.toString(), 'userId': userId});
    if (response.statusCode == 200)
      return 200;
    else if (response.statusCode == 450)
      return 450; //user in album
    else
      return 400;
  }

  Future<void> deleteImage(int albumId, int imageId) async {
    var url = host + 'deleteImage/$imageId';
    var response = await http.delete(url);
    if (response.statusCode != 200) throw Exception('Could not delete image');
  }

  Future<List<UserAccount>> getAttendees(int albumId) async {
    var url = host + 'getAttendees/${albumId.toString()}';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<UserAccount> attendees =
          jsonResponse.map((data) => UserAccount.fromJson(data)).toList();
      return attendees;
    } else {
      throw Exception('Could not fetch album attendees');
    }
  }
}
