import 'dart:ffi';

import 'package:chat_me/auth/authenticate.dart';
import 'package:chat_me/model/user.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // get user id from firebase
  UserId? getUserFromFirebase(User user) {
    return user != null ? UserId(uid: user.uid) : null;
  }

  Stream<UserId?> get user {
    return auth
        .authStateChanges()
        .map((User? user) => getUserFromFirebase(user!));
  }

  //register with email and password
  Future registerWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return getUserFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return getUserFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out
  Future signOut() async {
    try {
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
