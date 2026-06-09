import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/chat/model/chat_model.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/time_format/time_convertor.dart';
import '../../user/service/get_userIds.dart';

class MessageService {
  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // Example: "02:30 PM"
  }

  Future<void> sendMessage(String message, String uId1, String uId2) async {
    try {

      CollectionReference messages = FirebaseFirestore.instance
          .collection("chats")
          .doc(getChatId(uId1, uId2))
          .collection("messages");
      String docId = '';
      await messages
          .add({
            "docId": docId,
            "chatId": getChatId(uId1, uId2),
            "message": message,
            "senderId": uId1,
            "receiverId": uId2,
            "messageTime": formatTimeWithSeconds(DateTime.now()),
            "status":"uploading",
            // Firestore server time
          })
          .then((DocumentReference doc) {
            messages.doc(doc.id).update({"docId": doc.id});
            // print("------------${doc.id}----------");
          });

      print("WORKING");
    } catch (e) {
      print("Message Didnt Send");
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
  Future<void> sendedMessages(String uId1, String uId2, String docId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(getChatId(uId1, uId2))
        .collection("messages")
        .doc(docId)
        .set({'status' :"sent"});
    //    await FirebaseFirestore.instance.collection('requests').doc(docId).set(
    //       {'requestStatus': true},
    //       SetOptions(merge: true),

    print("Message Sent");
  }
}
