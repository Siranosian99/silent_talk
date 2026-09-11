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

  Future<List<ChatHistoryModel>> getMessagesById(String userId) async {
    try {
      CollectionReference chats = FirebaseFirestore.instance
          .collection('ai_chats')
          .doc(userId)
          .collection('messages');
      QuerySnapshot snapshot =
          await chats.orderBy('createdAt', descending: true).get();
      final data =
          snapshot.docs.map((doc) {
            return ChatHistoryModel(
              userId: doc['userId'],
              id: doc['id'],
              title: doc['title'],
              userMessage: doc['userMessage'],
              aiResponse: doc['aiResponse'],
              createdAt: (doc['createdAt'] as Timestamp).toDate(),
            );
          }).toList();

      print("------------$data");
      return data;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }

  Future<ChatHistoryModel?> getMessageById( String docId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('ai_chats')
              .doc(_authenticator.getUserId())
              .collection('messages')
              .doc(docId)
              .get();
      if (!doc.exists) return null;

      final data = doc.data()!;

      return ChatHistoryModel(
        userId: data['userId'],
        id: data['id'],
        title: data['title'],
        userMessage: data['userMessage'],
        aiResponse: data['aiResponse'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );

    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return null;
    }
  }

  // Future<String> getMessages()async{
  // }
}
