import 'package:point_of_view/managers/auth_manager.dart';
import 'package:point_of_view/services/user_service.dart';
import 'package:point_of_view/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthService {
  Future<bool> validateUsername(String username);
  Future<String> register(String username, String password, String email,
      String name, String imagePath);
  Future<void> signOut();
  Future<String> login(String email, String password);
}

class AuthServiceImplementation implements AuthService {
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

      locator<UserService>()
          .uploadProfileImg(locator<AuthManager>().getImage.lastResult);
    } else {
      return 'username-taken';
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
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
