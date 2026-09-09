class ChatHistoryModel {
  final String id;
  final String title;
  final String userMessage;
  final String aiResponse;
  final DateTime createdAt;

  ChatHistoryModel({
    required this.id,
    required this.title,
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
  });
}