import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/auth/services/authenticator.dart';
import 'package:silent_talk/features/chat/model/ai_message_model.dart';

import '../../chat/model/chat_model.dart';

class AiBackend {
  final Authenticator _authenticator = Authenticator();

  // String? conversationId;
  String? chatId;

  Future<String?> sendAiMessage(
    String aiMessage,
    String uId1,
    String userMessage,
    // MessageModel message,
  ) async {
    try {
      // conversationId ??=
      //     FirebaseFirestore.instance.collection('ai_chats').doc().id;
      chatId ??= '${uId1}_${DateTime.now().millisecondsSinceEpoch}';
      final chatsCollection = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId);
      final messageDoc = chatsCollection.collection('messages');
      //
      // final docRef = messageDoc.doc();
      await chatsCollection.set({
        "userId": _authenticator.getUserId(),
        "id": chatId,
        "title": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await messageDoc.add({
        "role": 'user',
        "text": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await messageDoc.add({
        "role": 'assistant',
        "text": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await chatsCollection.update({'updatedAt': FieldValue.serverTimestamp()});
      print("save");
      return chatId;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }
  Future<String?> sendAiMessageWithId(
      String aiMessage,
      String uId1,
      String userMessage,
      String chatId
      // MessageModel message,
      ) async {
    try {
      // conversationId ??=
      //     FirebaseFirestore.instance.collection('ai_chats').doc().id;
      final chatsCollection = FirebaseFirestore.instance
          .collection("ai_chats")
          .doc(chatId);
      final messageDoc = chatsCollection.collection('messages');
      //
      // final docRef = messageDoc.doc();
      await chatsCollection.set({
        "userId": _authenticator.getUserId(),
        "id": chatId,
        "title": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await messageDoc.add({
        "role": 'user',
        "text": userMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });
      await messageDoc.add({
        "role": 'assistant',
        "text": aiMessage,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await chatsCollection.update({'updatedAt': FieldValue.serverTimestamp()});
      print("save");
      return chatId;
    } catch (e) {
      print("Message Didnt Send");
      return '';
    }
  }
  Future<List<ChatModel>> getMessagesById(String userId) async {
    try {
      List<ChatModel> allData = [];
      final chats = FirebaseFirestore.instance
          .collection('ai_chats')
          .where("userId", isEqualTo: userId);
      QuerySnapshot snapshot = await chats.get();

      for (var doc in snapshot.docs) {
        final data =
        await doc.reference
            .collection('messages')
            .orderBy('createdAt')
            .get();
        final message =
        data.docs.map((messageDoc) {
          final messageData = messageDoc.data();

          return MessageModel(
            role: messageData['role'],
            text: messageData['text'],
            createdAt: (messageData['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        allData.add(ChatModel( userId: doc['userId'],
          id: doc['id'],
          title: doc['title'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
          messages: message,)

        );

      }
      return allData;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }

  Future<List<ChatModel>> getMessageById(String docId) async {
    try {
      List<ChatModel> allData = [];
      final chats = FirebaseFirestore.instance
          .collection('ai_chats')
          .where("id", isEqualTo: docId);
      QuerySnapshot snapshot = await chats.get();

      for (var doc in snapshot.docs) {
        final data =
        await doc.reference
            .collection('messages')
            .orderBy('createdAt')
            .get();
        final message =
        data.docs.map((messageDoc) {
          final messageData = messageDoc.data();

          return MessageModel(
            role: messageData['role'],
            text: messageData['text'],
            createdAt: (messageData['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        allData.add(ChatModel( userId: doc['userId'],
          id: doc['id'],
          title: doc['title'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
          messages: message,)

        );

      }
      return allData;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }


}

//Collection all Data of ai_chats after that we called all ai_chats that include userId
// becuase the messages are new document not inside the ai_chats so we call the messages document which include userId
//