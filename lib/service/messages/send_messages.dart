import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/service/model/chat_model.dart';
import 'package:intl/intl.dart';

import '../../utils/time_format/time_convertor.dart';
import '../ids/get_userIds.dart';

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
      final querySnapshot = await messages
          .get();

      await messages.add({
        "docId": "ids[1]",
        "chatId":getChatId(uId1, uId2),
        "message": message,
        "senderId": uId1,
        "receiverId": uId2,
        "messageTime": formatTimeWithSeconds(DateTime.now()), // Firestore server time
      });


      for (var doc in querySnapshot.docs) {
        print("Document ID: ${doc.id}");
        // ids.add();
        // ids.clear();
        print("Data: ${doc.data()}");
      }
      print("WORKING");
    } catch (e) {
      print("Message Didnt Send");
    }
  }
    Future<void> deleteMessage(String uId1, String uId2) async {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(getChatId(uId1, uId2))
          .collection("messages")
          .doc("Ud9DufK2tyEZoqPqx66p")
          .delete();

      print("Message ss deleted");
    }


}
