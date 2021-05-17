import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:quick_service_clone/models/user_data.dart';
import 'package:quick_service_clone/services/database_service.dart';
import 'package:quick_service_clone/services/storage_service.dart';
import 'package:quick_service_clone/shared/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future changePassword(String newPassword) async{
    try {






      await _auth.currentUser.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }



  String get currentUserUid {
    return _auth.currentUser.uid;
  }


  Stream<User> get user {
    return _auth.authStateChanges();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  bool checkIfEmailVerified() {
    return _auth.currentUser.emailVerified;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (checkIfEmailVerified()) {
        print('Login successful');
        return 'Login succesful, choose mode.';
      } else {
        print('Verification needed');
        return 'Verify email address';
      }
    } on FirebaseAuthException catch (e) {
      print('Exception caught');
      return e;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, UserData userData, File imageFile) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //Send verification
      user.sendEmailVerification();
      //Save image to storage and to database

      if (imageFile != null) {
        dynamic response =
            await StorageService(uid: user.uid).uploadProfileImage(imageFile);

        if (response is Exception) {
          userData.profileImageUrl = defaultNewUser;
          await DatabaseService(uid: user.uid).updateUserData(userData);
        } else {
          await StorageService()
              .profileImagesRef
              .child(user.uid)
              .getDownloadURL()
              .then((imgUrl) async {
            userData.profileImageUrl = imgUrl;
            await DatabaseService(uid: user.uid).updateUserData(userData);
          });
        }
      } else {
        userData.profileImageUrl = defaultNewUser;
        await DatabaseService(uid: user.uid).updateUserData(userData);
      }
      //Return the user
      return user;
    } on FirebaseAuthException catch (e) {
      //return an error message not a user
      return e.message.toString();
    }
  }
}
