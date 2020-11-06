import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_view/core/services/auth_service.dart';
import '../../locator.dart';

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  AuthService _authService = locator<AuthService>();

  void uploadImage(String image, String location, String eventId) async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(location);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(image));
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) => {
          FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .update({'image': value})
        });
  }
}
