class ChatHistoryModel {
  final String conversationId;
  final String userId;
  final String id;
  final String title;
  final String userMessage;
  final String aiResponse;
  final DateTime createdAt;

  ChatHistoryModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
    required this.conversationId,
  });

  @override
  String toString() {
    return 'ChatHistoryModel('
        'conversationId: $conversationId, '
        'userId: $userId, '
        'id: $id, '
        'title: $title, '
        'userMessage: $userMessage, '
        'aiResponse: $aiResponse, '
        'createdAt: $createdAt'
        ')';
  }
}
