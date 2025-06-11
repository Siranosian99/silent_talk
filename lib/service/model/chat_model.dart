import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:silent_talk/service/model/user_model.dart';

class ChatModel {
  final String chatId;
  final List<Users> users;
  final String? lastMessage;
  final DateTime? lastUpdated;

  ChatModel({
    required this.chatId,
    required this.users,
    this.lastMessage,
    this.lastUpdated,
  });

  // From Firestore
  factory ChatModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatModel(
      chatId: id,
      users: List<Users>.from(map['users']),
      lastMessage: map['lastMessage'],
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'lastMessage': lastMessage,
      'lastUpdated': lastUpdated,
    };
  }
}
