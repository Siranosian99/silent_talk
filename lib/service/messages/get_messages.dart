import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/service/model/chat_model.dart';

class GetMessageService{
  List<ChatModel> chats=[];
  Future<List<ChatModel>> getChats() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc('7ouy2IIWmkZz0jhWvKtJnTuk0j62_jrBpZPFsMfYz2j8h8FM9HKBQ9QG3') // Chat ID
        .collection('messages')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ChatModel(
        chatId: data['chatId'] ?? '',
        senderId: data['senderId'] ?? '',
        receiverId: data['receiverId'] ?? '',
        messageTime: data['messageTime']?.toString() ?? '', message: data['message'] ?? '',
      );
    }).toList();
  }

}