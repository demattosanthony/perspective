import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:better_uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChange => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  void uploadProfileImage(
      String profileImage, UserCredential userCredential, String name) async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('user_profile_images/${name}');
    StorageUploadTask uploadTask;
    if (profileImage == null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .update({'profileImage': null});
      print('here');
    } else {
      uploadTask = firebaseStorageRef.putFile(File(profileImage));
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) => {
            FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user.uid)
                .update({'profileImage': value})
          });
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password, String userName, String profileImage, String name) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .set({
        'uid': userCredential.user.uid,
        'username': userName,
        'password': password,
        'email': email,
        'followingCount': 0,
        'followersCount': 0,
        'name' : name
      });

      var id = Uuid.v1();

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .collection('followers')
          .doc(Uuid.v1().toString())
          .set({});

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .collection('following')
          .doc(Uuid.v1().toString())
          .set({});

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .collection('attendedEvents')
          .doc(Uuid.v1().toString())
          .set({});
      
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .collection('createdEvents')
          .doc(Uuid.v1().toString())
          .set({});
      
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user.uid)
          .collection('planningOnAttendingEvents')
          .doc(Uuid.v1().toString())
          .set({});

      uploadProfileImage(profileImage, userCredential, name);

      if (userCredential != null) return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (user != null) return true;

    return false;
  }

  signOut() {
    return _firebaseAuth.signOut();
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
