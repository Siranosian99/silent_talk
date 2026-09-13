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

  //
  // Future<List<ChatModel>> getMessagesById(String userId) async {
  //   try {
  //     CollectionReference chats = FirebaseFirestore.instance
  //         .collection('ai_chats').where("userId",is)
  //         .doc(userId)
  //         .collection('messages')
  //         .doc("MReMRdcH5hPSjNx64AQEswyz8No1_1789233402569")
  //         .collection("conversations");
  //     QuerySnapshot snapshot =
  //         await chats
  //             .where(
  //               "conversationId",
  //               isEqualTo: "MReMRdcH5hPSjNx64AQEswyz8No1_1789233402569",
  //             )
  //             .get();
  //     final data =
  //         snapshot.docs.map((doc) {
  //           return ChatModel(
  //             userId: doc['userId'],
  //             id: doc['id'],
  //             title: doc['title'],
  //             createdAt: (doc['createdAt'] as Timestamp).toDate(),
  //             updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
  //           );
  //         }).toList();
  //
  //     print("------------$data");
  //     return data;
  //   } catch (e) {
  //     print('Errssor fetching messages by id: $e');
  //     return [];
  //   }
  // }
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
        print(data);

      }

      print("------------$allData");
      return allData;
    } catch (e) {
      print('Errssor fetching messages by id: $e');
      return [];
    }
  }

  // Future<ChatModel?> getMessageById() async {
  //   try {
  //     final doc =
  //         await FirebaseFirestore.instance
  //             .collection('ai_chats')
  //             .doc(_authenticator.getUserId())
  //             .collection('messages')
  //             .doc('docId')
  //             .get();
  //     if (!doc.exists) return null;
  //
  //     final data = doc.data()!;
  //
  //     return AiMess(
  //       conversationId: data['conversationId'],
  //       userId: data['userId'],
  //       id: data['id'],
  //       title: data['title'],
  //       userMessage: data['userMessage'],
  //       aiResponse: data['aiResponse'],
  //       createdAt: (data['createdAt'] as Timestamp).toDate(),
  //     );
  //   } catch (e) {
  //     print('Errssor fetching messages by id: $e');
  //     return null;
  //   }
  // }
}

//Collection all Data of ai_chats after that we called all ai_chats that include userId
// becuase the messages are new document not inside the ai_chats so we call the messages document which include userId
//