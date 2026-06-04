import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/features/user/service/get_userIds.dart';
import 'package:silent_talk/features/chat/model/chat_model.dart';

class GetMessageService {
  List<ChatModel> chats = [];

  Future<List<ChatModel>> getChats(String uid1, String uid2) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(getChatId(uid1, uid2)) // Chat ID
            .collection('messages')
            .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ChatModel(
        senderAccept: data['senderAccept'],
        receiverAccept: data['receiverAccept'],
        docId: data['docId'],
        chatId: data['chatId'] ?? '',
        senderId: data['senderId'] ?? '',
        receiverId: data['receiverId'] ?? '',
        messageTime: data['messageTime']?.toString() ?? '',
        message: data['message'] ?? '',
      );
    }).toList();
  }
}
