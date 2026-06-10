import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/chat/model/chat_model.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/time_format/time_convertor.dart';
import '../../user/service/get_userIds.dart';

class MessageService {
  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // Example: "02:30 PM"
  }

  Future<String> sendMessage(String message, String uId1, String uId2) async {
    try {

      final messages = FirebaseFirestore.instance
          .collection("chats")
          .doc(getChatId(uId1, uId2))
          .collection("messages");
      final docRef =messages.doc();
      await docRef.set({
            "docId": docRef.id,
            "chatId": getChatId(uId1, uId2),
            "message": message,
            "senderId": uId1,
            "receiverId": uId2,
            "messageTime": formatTimeWithSeconds(DateTime.now()),
            // Firestore server time
          });
      print("WORKING");
      return docRef.id;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }

  Future<void> deleteMessage(String uId1, String uId2, String docId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(getChatId(uId1, uId2))
        .collection("messages")
        .doc(docId)
        .delete();

    print("Message ss deleted");
  }
  Future<void> updateMessages(String message,String uId1, String uId2, String docId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(getChatId(uId1, uId2))
        .collection("messages")
        .doc(docId)
        .update({'message' :message});
    //    await FirebaseFirestore.instance.collection('requests').doc(docId).set(
    //       {'requestStatus': true},
    //       SetOptions(merge: true),

    print("Message Updated");
  }
}
