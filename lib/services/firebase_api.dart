import 'package:chat_me/screens/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  fetchUserfromFirebase() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  // fetchMessagesfromFirebase(String userId) {
  //   return FirebaseFirestore.instance
  //       .collection('chats/$userId/messages')
  //       .snapshots();
  // }

  fetchCurrentUserId() {
    FirebaseFirestore.instance.collection('users').id;
  }

  static Future uploadMessage(
      String? sender, String? userId, String message) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$userId/messages');
    var currentUser =
        FirebaseFirestore.instance.collection('users').snapshots();
    var loggedInUser = FirebaseAuth.instance.currentUser!.uid;

    final newMessage = Message(
      idUser: loggedInUser,
      sender: sender!,
      message: message,
      createdAt: DateTime.now(),
      imageAvatar:
          'https://www.google.com/search?sxsrf=ALiCzsZDfWZubx6wRa2CyEjypigtWygvlQ:1662798733350&q=Fawad+Khan&stick=H4sIAAAAAAAAAE2TvW_TQBjG7VSkiUtF4hZUZaFEDCUDie1zYpehSBQWoBWhSEggjO2L4_jj7ORMHGdBQvwBiKFCYkAwIcHOxwAVTHRgKFIHEBSBBCoLYkB8SEi05S5lu5-f93kfve-dMzuKXNkvVyCuIVsUd4W628KRjlqTuhkFnWX2P5UAEKqaswHZTTAVHypEQIrmyTIBR5MTw1lmR8vNsiCYQteNJZW2CA0Ft0MqGj1D6UGhSdlyEhDiTpUUNx3FdRHJczFUu1RIBNwcgAxqEAzyJCTGFdGmbFctH_Sk3nYEErsG8ohZ7ifAkklEVVTgdqEstTGyvAEDB2uWGBJjFfgyVCnEtaZLFaHjqaFIbTDpW0BznUGeF5sayVM9o1ujK1RjyRLoSLHcFejKvDBOKhq9gqqMESR-uV1TaGpb6gPNIAJwXalPGxuK6nn00oxQgEToSgLoU4DNsJlEpApayHGoQ5V8uh8FJGqNnEXZdAAxG75bSwaLgn2cmEoHE7FjmVUMBotS7AoFW0Ju3Ke95Yro0hckgQgYdGNmpS2rpKqJTQdRuywqYviBXU6N5NZ_vhsrLKWu33-xyj5KcbkTQYAbXlJveHrUgAsBP8elj6KoFSX8zgLHZbYaY0MoTBa50d-fC_zuG-qZAyU-u_fSn58r9TdK_vz18U8_bj84Jo5z_8Zyq65pQyXM3Xq_yPIXuZHTjWghOBnAlpXwp_h5Lnuy4RuNDp63-P0cdyTwvIYZtQLE7ymMc3zZHHwob_1guDhR35pDtDu20K4Pb57jmrnEpqZTU2yxLV54vLL4Mn02_3CWYSbS9cOFqVKeS88Gvt5C-ZvT99YO7vk6UxrjMgt6L0CBn-TXhr6vfVz_OlPcl507lL147vmnmfzVb78uv_7ydmZiaJKZYoRXq8Pv09rvpyVmI-jKk7vP0pkMm2PEVIbpMzvv7OCO6bEOJ4_bOrqWZv8CFCEgMyUEAAA&sa=X&ved=2ahUKEwjb9NX-54n6AhU6W_EDHX6mDuAQ-BZ6BAgSEAY',
    );
    await refMessages.add(newMessage.toJson());

    // final refUser = FirebaseFirestore.instance.collection('users');
    // refUser.doc(userId).update(data);
  }
}
