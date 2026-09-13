import 'ai_message_model.dart';

class ChatModel {
  final String userId;
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageModel> messages;

  ChatModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  ChatModel copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      userId: userId,
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  @override
  String toString() {
    return 'ChatModel('
        'userId: $userId, '
        'id: $id, '
        'title: $title, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'messages: $messages'
        ')';
  }
}
