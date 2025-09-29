import 'package:cloud_firestore/cloud_firestore.dart';

import '../ids/get_userIds.dart';

class NotificationService {
  Future<void>notificationCheck(String user1,String user2)async{
    FirebaseFirestore.instance
        .collection("chats")
        .doc(getChatId(user1, user2))
        .collection("messages")
        .orderBy("messageTime", descending: false)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          print("New message added: ${change.doc.data()}");
          // 👉 You can trigger local notification here
        }
      }
    });

  }
}
