import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/chat/ai_chat_history_model.dart';

class AiBackend {
  final Authenticator _authenticator = Authenticator();


  Future<String> sendAiMessage(
    String aiMessage,
    String uId1,
    String userMessage,
  ) async {
    try {
      // final now = DateTime.now();
      final chatId = uId1;
      final messages = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId)
          .collection("messages");

      final docRef = messages.doc();
      await docRef.set({
        "userId": _authenticator.getUserId(),
        "id": docRef.id,
        "title": 'title',
        "userMessage": userMessage,
        "aiResponse": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),


      });
      print("save");
      return docRef.id;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }

  Future<List<ChatHistoryModel>> getMessageById(String userId) async {
    try {
      CollectionReference chats = FirebaseFirestore.instance.collection('ai_chats').doc().collection('messages');
      List<ChatHistoryModel> chat = [];
      QuerySnapshot snapshot =
          await chats.where("userId", isEqualTo: 'MReMRdcH5hPSjNx64AQEswyz8No1').get();
      final data =
          snapshot.docs.map((doc) {
            return ChatHistoryModel(
              userId: doc['userId'],
              id: doc['id'],
              title: doc['title'],
              userMessage: doc['userMessage'],
              aiResponse: doc['aiResponse'],
              createdAt: doc['createdAt'],
            );
          }).toList();
      chat = data;
      print("------------$chat");
      return chat;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }

  // Future<String> getMessages()async{
  // }
}
