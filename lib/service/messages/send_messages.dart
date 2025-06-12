import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/service/model/chat_model.dart';
import 'package:intl/intl.dart';

class MessageService {
  String getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort(); // ensures same order
    return ids.join("_");
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // Example: "02:30 PM"
  }

  Future<void> sendMessage(String message, String uId1, String uId2) async {
    try {
      CollectionReference messages = FirebaseFirestore.instance
          .collection("chats")
          .doc(getChatId(uId1, uId2))
          .collection("messages");

      await messages.add({
        "chatId":getChatId(uId1, uId2),
        "message": message,
        "senderId": uId1,
        "receiverId": uId2,
        "messageTime": formatTime(DateTime.now()), // Firestore server time
      });
      print("WORKING");
    } catch (e) {
      print("Message Didnt Send");
    }
  }
}
