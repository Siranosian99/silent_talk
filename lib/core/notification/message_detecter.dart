import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';

import '../../features/user/service/get_userIds.dart';
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
    String tokenU1 = await getUsersToken(user1);
    String tokenU2 = await getUsersToken(user2);
    String userNameU1 = await getUserName(user1);
    String userNameU2 = await getUserName(user2);
    bool isInitial = true; // 🔹 Flag to skip first snapshot

    _firebase
        .collection("chats")
        .doc(getChatId(user1, user2))
        .collection("messages")
        .orderBy("messageTime", descending: false)
        .snapshots()
        .listen((snapshot) async {
      if (isInitial) {
        isInitial = false;
        return; // 🔹 Skip initial load (old messages)
      }
      for (var change in snapshot.docChanges) { {
              String senderId = change.doc['senderId'];
              String receiverId = change.doc['receiverId'];
              String receiverToken = senderId == user1 ? tokenU2 : tokenU1;
              String senderName = senderId == user1 ? userNameU1 : userNameU2;
              if(receiverId !=Authenticator().user?.uid){
              await NotificationService.sendNotification(
                receiverToken,
                senderName,
                change.doc['message'],
                change.doc['senderId'],
                change.doc['receiverId'],
              );
            }}
          }
        });
  }
}
