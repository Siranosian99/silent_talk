import 'package:cloud_firestore/cloud_firestore.dart';


class AiBackend {
  Future<String> sendAiMessage(
    String aiMessage,
    String uId1,
    String userMessage,
  ) async {
    try {
      final now = DateTime.now();
      final chatId = '${uId1}_${now.millisecondsSinceEpoch}';
      final messages = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId)
          .collection("messages");

      final docRef = messages.doc();
      await docRef.set({
        "id": docRef.id,
        "title": 'title',
        "userMessage": userMessage,
        "aiResponse": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),

        //  final String id;
        //   final String title;
        //   final String userMessage;
        //   final String aiResponse;
        //   final DateTime createdAt;
      });
      print("save");
      return docRef.id;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }
  // Future<String> getMessages()async{
  // }
  // Future<String> getMessagesById(String userId)async{
  // }
}
