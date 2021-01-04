import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:point_of_view/models/Album.dart';
import 'package:point_of_view/models/Photo.dart';

abstract class AlbumService {
  Stream<List<Album>> getCreatedAlbums();
  Stream<List<Album>> getJoinedAlbums();
  Stream<List<Photo>> getPhotos(String albumId);
  Future<void> joinAlbum(String albumId);
  Future<void> createAlbum(String albumTitle);
  void deleteOrLeaveAlbum(String albumId, bool isOwner);
  Future<String> getUserProfileImg(String userId);
  Future<void> uploadImage(String imagePath, String albumId);
}

class AlbumServiceImplementation implements AlbumService {
  var host = "https://hidden-woodland-36838.herokuapp.com/";

  @override
  Stream<List<Album>> getCreatedAlbums() {
    String userId = FirebaseAuth.instance.currentUser.uid;
    var ref = FirebaseFirestore.instance
        .collection("albums")
        .where("userId", isEqualTo: userId)
        .snapshots();
    return ref.map((list) {
      return list.docs.map((doc) => Album.fromSnap(doc)).toList();
    });
  }

  Stream<List<Album>> getJoinedAlbums() {
    String userId = FirebaseAuth.instance.currentUser.uid;
    var ref = FirebaseFirestore.instance
        .collection("albums")
        .where("attendeeIds", arrayContains: userId)
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
  void deleteOrLeaveAlbum(String albumId, bool isOwner) async {
    if(isOwner) {
      FirebaseFirestore.instance.collection("albums").doc(albumId).delete();
    } else {
      FirebaseFirestore.instance.collection("albums").doc(albumId).update({
        'attendeeIds': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser.uid])
      });
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

    if (!userInAlbum) {
      await FirebaseFirestore.instance
          .collection("albums")
          .doc(albumId)
          .update({
        "attendeeIds": [userId]
      });
    }
  }
}
