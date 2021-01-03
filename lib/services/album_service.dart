import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:point_of_view/locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';
import 'package:point_of_view/services/user_service.dart';

abstract class AlbumService {
  Stream<List<Album>> getAlbums();
  Stream<List<Photo>> getPhotos(String albumId);
  Future<void> createAlbum(String albumTitle);
  Future<int> joinAlbum(String sharedString);
  void deleteAlbum(int albumId, bool isOwner);
  Future<String> getUserProfileImg(String userId);
  Future<void> uploadImage(String imagePath, String albumId);
}

class AlbumServiceImplementation implements AlbumService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";

  @override
  Stream<List<Album>> getAlbums() {
    String userId = FirebaseAuth.instance.currentUser.uid;
    var ref = FirebaseFirestore.instance
        .collection("albums")
        .where("userId", isEqualTo: userId)
        .snapshots();
    return ref.map((list) {
      return list.docs.map((doc) => Album.fromSnap(doc)).toList();
    });
  }

  Future<String> getUserProfileImg(String userId) async {
    var user =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return user['profileImgUrl'];
  }

  @override
  Future<void> createAlbum(String albumTitle) async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection("albums")
        .add({"title": albumTitle, "userId": userId}).then((value) => {
              FirebaseFirestore.instance
                  .collection("albums")
                  .doc(value.id)
                  .update({"albumId": value.id})
            });
  }

  Future<void> uploadImage(String imagePath, String albumId) async {
    File file = File(imagePath);

    try {
      TaskSnapshot result = await FirebaseStorage.instance
          .ref('albumImages/$albumId/$file')
          .putFile(file);
      result.ref.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection("albums")
                .doc(albumId)
                .collection("photos")
                .add({"imageUrl": value})
          });
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  @override
  Stream<List<Photo>> getPhotos(String albumId) {
    var ref = FirebaseFirestore.instance
        .collection("albums")
        .doc(albumId)
        .collection("photos")
        .snapshots();

    return ref.map((list) {
      return list.docs.map((doc) => Photo.fromSnap(doc)).toList();
    });
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

  @override
  Future<int> joinAlbum(String sharedString) async {
    var client = http.Client();
    try {
      int userId = 42;
      var url = host + "getAlbumIdFromShareString/$sharedString";
      var response = await http.get(url);
      var albumId = jsonDecode(response.body)[0]['album_id'];
      Map body = {"albumId": albumId.toString(), "userId": userId.toString()};
      var joinAlbumUrl = host + "joinAlbum";
      var joinAlbumRes = await http.post(joinAlbumUrl, body: body);
      if (joinAlbumRes.statusCode == 200) {
        return 200;
      } else if (joinAlbumRes.statusCode == 450) {
        //User already in album
        return 450;
      } else {
        return 400;
      }
    } catch (e) {
      throw Exception("Error joing album");
    } finally {
      client.close();
    }
  }
}
