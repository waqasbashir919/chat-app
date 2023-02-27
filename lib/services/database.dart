import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //search by username from firebase
  // getUserByUsername(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: username)
  //       .get();
  // }

  uploadUserInfo(userInfo,String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).set(userInfo);
  }
}
