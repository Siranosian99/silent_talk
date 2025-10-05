import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/service/notification/get_token.dart';

import '../ids/get_userIds.dart';
import 'notification_helper.dart';

class MessageChanger {
  final _firebase = FirebaseFirestore.instance;

  Future<String> getUsersToken(String userId) async {
    DocumentSnapshot doc =
        await _firebase.collection("users").doc(userId).get();

    String token = doc['token']; // only the token field

    return token;
  }
  Future<String> getUserName(String userId) async {
    DocumentSnapshot doc =
    await _firebase.collection("users").doc(userId).get();

    String uname = doc['userName']; // only the token field

    return uname;
  }
  Future<void> notificationCheck(String user1, String user2) async {
    String tokenU1=await getUsersToken(user1);
    String tokenU2=await getUsersToken(user2);
    String userNameU1=await getUserName(user1);
    String userNameU2=await getUserName(user2);
    _firebase
        .collection("chats")
        .doc(getChatId(user1, user2))
        .collection("messages")
        .orderBy("messageTime", descending: false)
        .snapshots()
        .listen((snapshot) async {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              String senderId = change.doc['senderId'];
              String receiverToken = senderId == user1 ? tokenU2 : tokenU1;
              NotificationService.sendNotification(
                receiverToken,
                senderId == user1 ? userNameU1 : userNameU2,
                change.doc['message'],

              );
              print("New message added: ${change.doc.data()}");
              // 👉 You can trigger local notification here
            }
          }
        });
  }
}
