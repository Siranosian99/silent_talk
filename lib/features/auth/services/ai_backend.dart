import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/chat/model/ai_message_model.dart';

class AiBackend {
  final Authenticator _authenticator = Authenticator();
  // String? conversationId;
  String? chatId;

  Future<String> sendAiMessage(
    String aiMessage,
    String uId1,
    String userMessage,
  ) async {
    try {
      // conversationId ??=
      //     FirebaseFirestore.instance.collection('ai_chats').doc().id;
      chatId ??= '${uId1}_${DateTime.now().millisecondsSinceEpoch}';
      final messages = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId)
          .collection('messages')
          .doc(chatId)
          .collection('conversations');

      final docRef = messages.doc();
      await docRef.set({
        "userId": _authenticator.getUserId(),
        "id": docRef.id,
        "title": 'title',
        "userMessage": userMessage,
        "conversationId": chatId,
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
          .collection('messages').doc("MReMRdcH5hPSjNx64AQEswyz8No1_1789233402569").collection("conversations");
      QuerySnapshot snapshot =
          await chats.where("conversationId",isEqualTo:"MReMRdcH5hPSjNx64AQEswyz8No1_1789233402569" ).get();
      final data =
          snapshot.docs.map((doc) {
            return ChatHistoryModel(
              conversationId: doc['conversationId'],
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

  Future<ChatHistoryModel?> getMessageById() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('ai_chats')
              .doc(_authenticator.getUserId())
              .collection('messages')
              .doc('docId')
              .get();
      if (!doc.exists) return null;

      final data = doc.data()!;

      return ChatHistoryModel(
        conversationId: data['conversationId'],
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


}

//ai_chats
// └── userId
//     └── chats
//         └── chatId
//             ├── title
//             ├── createdAt
//             ├── updatedAt
//             └── messages
//                 └── messageId
//                     ├── userMessage
//                     ├── aiResponse
//                     └── createdAt